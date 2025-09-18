using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class StatusReportApiController : ApiController
    {
        private readonly IBlobService _blobService;

        public StatusReportApiController()
        {
            _blobService = new BlobService();
        }
        [HttpPost]
        public string AddStatusConfiguration(StatusConfigurationModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Status Configuration", "Status Report Api"));
            try
            {
                if (ModelState.IsValid)
                {
                    using (var entities = new BViewEntities())
                    {
                        var userId = User.Identity.GetUserId<int>();
                        if (model.StatusSetTo != null)
                        {
                            var reportConfiguration = new SR_StatusReportingConfiguration
                            {
                                ReportText = model.StatusText,
                                StatusSetByUserId = userId,
                                StatusSetToUserId = (int)model.StatusSetTo,
                                CreatedDateTime = DateTime.UtcNow
                            };
                            entities.SR_StatusReportingConfiguration.Add(reportConfiguration);
                        }

                        entities.SaveChanges();
                        var latestId = entities.SR_StatusReportingConfiguration.Select(x => x.Id).Max();
                        foreach (var item in model.WorkingWeekOptions)
                        {
                            if (item != null)
                            {
                                var reportConfigDetails = new SR_StatusReportingConfigurationDetails
                                {
                                    StatusReportConfigurationId = latestId,
                                    ReportingOptionId = (Guid)item,
                                    ReportingStatusId = AppConstants.Working,
                                    CreatedDateTime = DateTime.UtcNow,
                                    CreatedByUserId = userId,
                                    UpdatedByUserId = null
                                };
                                entities.SR_StatusReportingConfigurationDetails.Add(reportConfigDetails);
                            }

                            entities.SaveChanges();
                        }
                        var finalResult = new BusinessViewJsonResult
                        {
                            Success = true,
                        };
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Status Report Submitted", "Status Report Api"));
                        return JsonConvert.SerializeObject(finalResult);
                    }

                }
                var result = new BusinessViewJsonResult
                {
                    Success = false,
                    ModelState = ModelState
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Status Configuration", "Status Report Api"));

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add Status Configuration", "Status Report Api", ex.Message));

                throw;
            }
        }

        [HttpPost]
        [System.Web.Mvc.ValidateInput(false)]
        public string StatusReportSubmitted()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Status Report Submitted", "Status Report Api"));

                using (var entities = new BViewEntities())
                {
                    var statusReportingModel = new StatusReportingModel();
                    var description = HttpContext.Current.Request.Unvalidated.Form.Get("StatusReportDescription");

                    if (!string.IsNullOrEmpty(description))
                    {
                        statusReportingModel.StatusReportDescription = description;
                    }
                    Validate(statusReportingModel);
                    if (!ModelState.IsValid)
                    {
                        var resultReturn = new BusinessViewJsonResult
                        {
                            Success = false,
                            ModelState = ModelState

                        };
                        return JsonConvert.SerializeObject(resultReturn);
                    }
                    int configurationId = Convert.ToInt32(HttpContext.Current.Request.Form["StatusReportConfigurationId"]);
                    var userId = Convert.ToInt32(HttpContext.Current.Request.Form["StatusSetTo"]);

                    var alreadySavedAttachmentDetails = entities.SR_StatusReporting.FirstOrDefault(x => x.StatusReportConfigurationId == configurationId && x.IsSubmitted == false && x.CreatedByUserId == userId);
                    int reportId;
                    if (alreadySavedAttachmentDetails != null)
                    {
                        alreadySavedAttachmentDetails.Description = statusReportingModel.StatusReportDescription;
                        alreadySavedAttachmentDetails.CreatedDateTime = DateTime.UtcNow;
                        alreadySavedAttachmentDetails.IsSubmitted = true;
                        alreadySavedAttachmentDetails.IsReviewed = false;
                        alreadySavedAttachmentDetails.CreatedByUserId = userId;
                        entities.SaveChanges();
                        reportId = alreadySavedAttachmentDetails.Id;
                    }
                    else
                    {
                        var statusReport = new SR_StatusReporting
                        {
                            StatusReportConfigurationId = configurationId,
                            Description = statusReportingModel.StatusReportDescription,
                            CreatedDateTime = DateTime.UtcNow,
                            IsSubmitted = true,
                            UpdatedByUserId = null,
                            IsReviewed = false,
                            CreatedByUserId = userId
                        };
                        entities.SR_StatusReporting.Add(statusReport);
                        entities.SaveChanges();
                        reportId = entities.SR_StatusReporting.ToList().Select(x => x.Id).Max();
                    }

                    var alreadySavedAttachments = entities.SR_StatusReportingAttachment.Where(x => x.StatusReportConfigurationId == configurationId && x.CreatedByUserId == userId && x.IsSubmitted == false && x.StatusReportId == reportId).ToList();
                    foreach (var attachment in alreadySavedAttachments)
                    {
                        attachment.IsSubmitted = true;
                        entities.SaveChanges();
                    }

                    var latestReportId = entities.SR_StatusReporting.ToList().Select(x => x.Id).Max();
                    int count = Convert.ToInt32(HttpContext.Current.Request.Form["AttachmentsCount"]);
                    for (int i = 0; i < count; i++)
                    {
                        var files = HttpContext.Current.Request.Files["StatusReportAttachments" + i];
                        if (files != null)
                        {
                            var name = Path.GetFileName(files.FileName);

                            var fileExtension = Path.GetExtension(name);

                            var isValidFile = IsFileTypeValid(fileExtension);
                            if (isValidFile)
                            {
                                var filePath = _blobService.UploadFile(files);
                                using (var bviewentities = new BViewEntities())
                                {
                                    var reportAttachments = new SR_StatusReportingAttachment
                                    {
                                        StatusReportId = latestReportId,
                                        AttachmentName = files.FileName,
                                        StatusReportConfigurationId = configurationId,
                                        AttachmentPath = filePath,
                                        CreatedDateTime = DateTime.UtcNow,
                                        CreatedByUserId = userId,
                                        UpdatedByUserId = null,
                                        IsSubmitted = true
                                    };
                                    bviewentities.SR_StatusReportingAttachment.Add(reportAttachments);
                                    bviewentities.SaveChanges();
                                }
                            }
                            else
                            {
                                ModelState.AddModelError("", "Attachment was not in correct format.");

                                var result2 = new BusinessViewJsonResult
                                {
                                    Success = false,
                                    ModelState = ModelState
                                };
                                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get File Path", "Food Orders Api"));
                                return JsonConvert.SerializeObject(result2);
                            }
                        }
                    }
                    var finalResult = new BusinessViewJsonResult
                    {
                        Success = true,
                    };
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Status Report Submitted", "Status Report Api"));
                    return JsonConvert.SerializeObject(finalResult);

                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Status Report Submitted", "Status Report Api", ex.Message));

                throw;
            }
        }

        [HttpPost]
        [System.Web.Mvc.ValidateInput(false)]
        public StatusReportingModel StatusReportSaved()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Status Report Submitted", "Status Report Api"));
                var statusReportingModel = new StatusReportingModel();
                var description = HttpContext.Current.Request.Unvalidated.Form.Get("StatusReportDescription");

                if (!string.IsNullOrEmpty(description))
                {
                    statusReportingModel.StatusReportDescription = description;
                }
                int configurationId = Convert.ToInt32(HttpContext.Current.Request.Form["StatusReportConfigurationId"]);
                var userId = Convert.ToInt32(HttpContext.Current.Request.Form["StatusSetTo"]);
                using (var bViewEntities = new BViewEntities())
                {
                    var alreadySavedAttachmentDetails = bViewEntities.SR_StatusReporting.FirstOrDefault(x => x.StatusReportConfigurationId == configurationId && x.IsSubmitted == false && x.CreatedByUserId == userId);
                    int reportId;
                    if (alreadySavedAttachmentDetails != null)
                    {
                        alreadySavedAttachmentDetails.Description = statusReportingModel.StatusReportDescription;
                        alreadySavedAttachmentDetails.CreatedDateTime = DateTime.UtcNow;
                        alreadySavedAttachmentDetails.IsSubmitted = false;
                        alreadySavedAttachmentDetails.CreatedByUserId = userId;
                        bViewEntities.SaveChanges();
                        reportId = alreadySavedAttachmentDetails.Id;
                    }
                    else
                    {
                        var statusReport = new SR_StatusReporting
                        {
                            StatusReportConfigurationId = configurationId,
                            Description = statusReportingModel.StatusReportDescription,
                            CreatedDateTime = DateTime.UtcNow,
                            IsSubmitted = false,
                            UpdatedByUserId = null,
                            CreatedByUserId = userId
                        };
                        bViewEntities.SR_StatusReporting.Add(statusReport);
                        bViewEntities.SaveChanges();
                        reportId = bViewEntities.SR_StatusReporting.ToList().Select(x => x.Id).Max();
                    }
                    int count = Convert.ToInt32(HttpContext.Current.Request.Form["AttachmentsCount"]);
                    for (int i = 0; i < count; i++)
                    {
                        var files = HttpContext.Current.Request.Files["StatusReportAttachments" + i];
                        if (files != null)
                        {
                            var name = Path.GetFileName(files.FileName);

                            var fileExtension = Path.GetExtension(name);

                            var isValidFile = IsFileTypeValid(fileExtension);
                            if (isValidFile)
                            {
                                var filePath = _blobService.UploadFile(files);
                                var reportAttachments = new SR_StatusReportingAttachment
                                {
                                    StatusReportId = reportId,
                                    AttachmentName = files.FileName,
                                    StatusReportConfigurationId = configurationId,
                                    AttachmentPath = filePath,
                                    CreatedDateTime = DateTime.UtcNow,
                                    CreatedByUserId = userId,
                                    IsSubmitted = false,
                                    UpdatedByUserId = null
                                };
                                bViewEntities.SR_StatusReportingAttachment.Add(reportAttachments);
                                bViewEntities.SaveChanges();
                            }
                        }
                    }

                    var model = new StatusReportingModel
                    {
                        StatusReportConfigurationId = configurationId,
                        ReportId = reportId,
                        StatusSetTo = userId
                    };
                    return model;
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Status Report Submitted", "Status Report Api", ex.Message));

                throw;
            }
        }


        private bool IsFileTypeValid(string fileExtension)
        {
            try
            {
                string[] validExtensions = { ".xls", ".pptx", ".ppt", ".doc", ".docx", ".xlsx", ".pdf", ".jpeg", ".jpg", ".gif", ".png", ".XLSX", ".PDF", ".JPEG", ".XLS", ".DOC", ".DOCX", ".JPG", ".GIF", ".PPTX", ".PPT", ".PNG" };

                if (validExtensions.Contains(fileExtension))
                {
                    return true;
                }

                return false;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);

                throw;
            }
        }
    }
}