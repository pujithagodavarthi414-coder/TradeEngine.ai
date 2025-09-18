using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;

namespace BusinessView.Api.Controllers.Api
{
    public class LeadsManagementApiController : ApiController
    {
        // GET: LeadsManagementApi
        private readonly ILeadsManagementsheet _leadsManagementsheetServices;
        private readonly IBlobService _blobService;
        private readonly IFileService _fileService;

        public LeadsManagementApiController()
        {
            _blobService = new BlobService();
            _fileService = new FileService();
            _leadsManagementsheetServices = new LeadsManagementsheet();
        }

        public List<LeadsManagementModel> Get()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Leads", "Api"));
            var Lead = new List<LeadsManagementModel>();

            try
            {
                Lead = _leadsManagementsheetServices.GetAllLeads();
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All Lead", "Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Lead", "Api"));

            return Lead;
        }

        [System.Web.Http.HttpPost]
        public string AddorUpdateLead(LeadsManagementModel leadsManagementSheet)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Lead", "Api"));
            if (ModelState.IsValid)
            {
                var result = _leadsManagementsheetServices.AddOrUpdate(leadsManagementSheet);
                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                    Result = result,
                };
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Lead", "Api"));
                return JsonConvert.SerializeObject(result1);
            }
            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Lead", "Api"));

            return JsonConvert.SerializeObject(result2);
        }

        [System.Web.Http.HttpPost]
        public string AddorUpdateLeadPersonalDetails(int leadId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Lead personal information", "Api"));
            if (ModelState.IsValid)
            {
                int count = Convert.ToInt32(HttpContext.Current.Request.Form["Count"]);
                var userId = User.Identity.GetUserId<int>();
                var notes = HttpContext.Current.Request.Form["Notes"];
                for (int i = 0; i < count; i++)
                {
                    var files = HttpContext.Current.Request.Files["Files" + i];

                    if (files != null)
                    {
                        var name = Path.GetFileName(files.FileName);

                        var fileExtension = Path.GetExtension(name);

                        if (files.ContentLength > 0)
                        {
                            var filePath = _blobService.UploadFile(files);
                            var fileName = files.FileName;

                            var file = new FilesModel
                            {
                                FilePath = filePath,
                                FileName = fileName,
                                CreatedOn = DateTime.Now,
                                CreatedBy = userId,
                                LeadId = leadId
                            };

                            _fileService.AddOrUpdate(file);

                            var updatedFile = "<li>" + "File " + "<a target='_blank' class='file-link' href='" +
                                              filePath + "'>" + fileName + "</a>" + " added </li>";
                        }
                    }
                }
                if(notes != "")
                {
                    var details = new LeadPersonalDetails
                    {
                        LeadId = leadId,
                        LeadNotes = notes
                    };
                    _leadsManagementsheetServices.AddOrUpdateLeadPersonalDetails(details);
                }
                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Lead personal information", "Api"));
                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Lead personal information", "Api"));

            return JsonConvert.SerializeObject(result2);
        }

        public string getLeadPersonalDetails(int leadId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Lead", "Api"));

            var getlead = new List<LeadPersonalDetails>();

            try
            {
                getlead = _leadsManagementsheetServices.GetLeadPersonalDetails(leadId);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Lead", "Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Lead", "Api"));

            return JsonConvert.SerializeObject(getlead);
        }
        [System.Web.Http.HttpPost]
        public string UpdateNotes(LeadPersonalDetails model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Notes", "Leads Management Api"));

            try
            {

               // var details = _leadsManagementsheetServices.ReadItem(model.NotesId);

                model.LeadNotes = model.LeadNotes;

                var result = _leadsManagementsheetServices.UpdateNotes(model);

                var data = new BusinessViewJsonResult
                {
                    Success = true,
                    Result = result
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Notes", "Leads Management Api"));

                return JsonConvert.SerializeObject(data);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update Notes", "Leads Management Api", ex.Message));

                throw;
            }
        }
        public string RemoveFile(int fileId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Remove Files", "Leads Management Api"));

            try
            {
                var result = _leadsManagementsheetServices.RemoveFiles(fileId);

                var data = new BusinessViewJsonResult
                {
                    Success = true,
                    Result = result
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Remove Files", "Leads Management Api"));

                return JsonConvert.SerializeObject(data);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Remove Files", "Leads Management Api", ex.Message));

                throw;
            }
        }
        [System.Web.Http.HttpPost]
        public string AddSnoozingTime(DateTime nextAction, int leadId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Snoozing Time", "Leads Management Api"));

            try
            {
                var result = _leadsManagementsheetServices.AddSnoozingTime(nextAction, leadId);

                var data = new BusinessViewJsonResult
                {
                    Success = true,
                    Result = result
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Snoozing Time", "Leads Management Api"));

                return JsonConvert.SerializeObject(data);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add Snoozing Time", "Leads Management Api", ex.Message));

                throw;
            }
        }

        public string UpdateLeadNextAction(int leadId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Lead NextAction Details", "Api"));

            var getlead = new List<LeadPersonalDetails>();

            try
            {
                _leadsManagementsheetServices.UpdateNextActionDetails(leadId);
                return "Action Completed successfully";
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update Lead NextAction Details", "Api", ex.Message));

                throw;
            }
        }
    }
}