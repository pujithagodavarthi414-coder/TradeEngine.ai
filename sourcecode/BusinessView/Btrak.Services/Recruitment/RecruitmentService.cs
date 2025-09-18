using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Crm.Call;
using Btrak.Models.File;
using Btrak.Models.GenericForm;
using Btrak.Models.MasterData;
using Btrak.Models.Recruitment;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Models.Widgets;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructure;
using Btrak.Services.CRM;
using Btrak.Services.Email;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.RecruitmentHelper;
using Btrak.Services.Projects;
using BTrak.Common;
using Hangfire;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace Btrak.Services.Recruitment
{
    public class RecruitmentService : IRecruitmentService
    {
        private readonly RecruitmentRepository _recruitmentRepository;
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private readonly IAuditService _auditService;
        private readonly UserRepository _userRepository;
        private readonly IEmailService _emailService;
        private readonly IRecruitmentMasterDataService _recruitmentMasterDataService;
        private readonly GoalRepository _goalRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly ITwilioWrapperClientService _twilioWrapperClientService;
        public RecruitmentService(RecruitmentRepository recruitmentRepository, IAuditService auditService, UserRepository userRepository,
            ICompanyStructureService companyStructureService, GoalRepository goalRepository, IEmailService emailService
            , MasterDataManagementRepository masterDataManagementRepository, IRecruitmentMasterDataService recruitmentMasterDataService, ITwilioWrapperClientService twilioWrapperClientService)
        {
            _recruitmentRepository = recruitmentRepository;
            _auditService = auditService;
            _userRepository = userRepository;
            _emailService = emailService;
            _recruitmentMasterDataService = recruitmentMasterDataService;
            _goalRepository = goalRepository;
            _companyStructureService = companyStructureService;
            _masterDataManagementRepository = masterDataManagementRepository;
            _twilioWrapperClientService = twilioWrapperClientService;
        }

        public Guid? UpsertCandidateJob(CandidateUpsertInputModel candidateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidates", "Recruitment Service"));
            LoggingManager.Debug(candidateUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidatesCommandId, candidateUpsertInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            candidateUpsertInputModel.CandidateId = _recruitmentRepository.UpsertCandidateJob(candidateUpsertInputModel, loggedInContext, validationMessages);
            return candidateUpsertInputModel.CandidateId;
        }

        public Guid? UpsertCandidate(CandidateUpsertInputModel candidateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Candidate", "Recruitment Service"));
            LoggingManager.Debug(candidateUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateCommandId, candidateUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateUpsertInputModel(candidateUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            CandidatesSearchInputModel candidatesSearchInputModel = new CandidatesSearchInputModel
            {
                Email = candidateUpsertInputModel.Email
            };
            if (candidateUpsertInputModel.CandidateId == null || candidateUpsertInputModel.CandidateId == Guid.Empty)
            {
                candidateUpsertInputModel.CandidateId = _recruitmentRepository.UpsertCandidate(candidateUpsertInputModel, loggedInContext, validationMessages);

                //notification for new Candidate
                if (candidateUpsertInputModel.CandidateId != null || candidateUpsertInputModel.CandidateId != Guid.Empty)
                {
                    candidatesSearchInputModel.CandidateId = candidateUpsertInputModel.CandidateId;
                    candidatesSearchInputModel.JobOpeningId = candidateUpsertInputModel.JobOpeningId;

                    //thread to send notification to Assigned manager and candidate when a new candidate is added
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        try
                        {
                            List<CandidatesSearchOutputModel> insertedNewCandidateModel =
                                _recruitmentRepository.GetCandidates(new CandidatesSearchInputModel
                                {
                                    CandidateId = candidatesSearchInputModel.CandidateId,
                                    JobOpeningId = candidatesSearchInputModel.JobOpeningId
                                }, loggedInContext,
                                    validationMessages);

                            if (insertedNewCandidateModel != null && insertedNewCandidateModel[0].AssignedToManagerId != loggedInContext.LoggedInUserId)
                            {
                                BackgroundJob.Enqueue(() =>
                                SendCandidateAssignedToManagerEmail(insertedNewCandidateModel[0], loggedInContext, validationMessages, true)
                                    )
                                    ;
                            }
                            if (insertedNewCandidateModel != null && insertedNewCandidateModel[0].CandidateId != loggedInContext.LoggedInUserId)
                            {
                                BackgroundJob.Enqueue(() =>
                            SendCandidateAddedEmail(insertedNewCandidateModel[0], loggedInContext, validationMessages, true, false)
                                    )
                                    ;
                            }
                        }
                        catch (Exception exception)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                        }
                    });
                }
            }
            else
            {
                List<CandidatesSearchOutputModel> oldCandidateModel =
                                _recruitmentRepository.GetCandidates(new CandidatesSearchInputModel
                                {
                                    CandidateId = candidateUpsertInputModel.CandidateId,
                                    JobOpeningId = candidateUpsertInputModel.JobOpeningId
                                }, loggedInContext,
                                    validationMessages);

                candidateUpsertInputModel.CandidateId = _recruitmentRepository.UpsertCandidate(candidateUpsertInputModel, loggedInContext, validationMessages);

                if ((oldCandidateModel[0].AssignedToManagerId == null && candidateUpsertInputModel.AssignedToManagerId != null) || (oldCandidateModel[0].AssignedToManagerId != candidateUpsertInputModel.AssignedToManagerId))
                {
                    
                    //thread to send notification to Assigned manager and candidate when a new candidate is added
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        try
                        {
                            List<CandidatesSearchOutputModel> insertedNewCandidateModel =
                                _recruitmentRepository.GetCandidates(new CandidatesSearchInputModel
                                {
                                    CandidateId = candidateUpsertInputModel.CandidateId,
                                    JobOpeningId = candidateUpsertInputModel.JobOpeningId
                                }, loggedInContext,
                                    validationMessages);
                            
                                BackgroundJob.Enqueue(() =>
                                SendCandidateAssignedToManagerEmail(insertedNewCandidateModel[0], loggedInContext, validationMessages, true));
                        }
                        catch (Exception exception)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                        }
                    });
                }
            }

            return candidateUpsertInputModel.CandidateId;
        }

        public string UpsertCandidateFormSubmitted(GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateFormSubmitted", "Recruitment Service"));

            CandidateFormInputModel candidateFormInputModel = JsonConvert.DeserializeObject<CandidateFormInputModel>(genericformSubmittedUpsertInputModel.FormJson);

            if(candidateFormInputModel.EducationDetails.Count > 0)
            {
                candidateFormInputModel.EducationDetailsXml = Utilities.ConvertIntoListXml(candidateFormInputModel.EducationDetails);
            }
            if (candidateFormInputModel.Experience.Count > 0)
            {
                candidateFormInputModel.ExperienceXml = Utilities.ConvertIntoListXml(candidateFormInputModel.Experience);
            }
            if (candidateFormInputModel.Skills.Count > 0)
            {
                candidateFormInputModel.SkillsXml = Utilities.ConvertIntoListXml(candidateFormInputModel.Skills);
            }
            if (candidateFormInputModel.Documents.Count > 0)
            {
                candidateFormInputModel.DocumentsList = new List<DocumentsList>();
                List<UploadedData> uploadedDocuments = new List<UploadedData>();
                var i = 0;
                foreach (var document in candidateFormInputModel.Documents)
                {
                    DocumentsList documentsList = new DocumentsList();
                    documentsList.Description = document.Description;
                    documentsList.DocumentName = document.DocumentName;
                    documentsList.DocumentType = document.DocumentType;
                    documentsList.Index = i;
                    UploadedData uploadedData = new UploadedData();
                    uploadedData.FilesList = new List<FileModel>();
                    uploadedData.Index = i;
                    foreach (var doc in document.UploadDocument)
                    {
                        FileModel fileModel = new FileModel();
                        foreach (var d in doc.Data)
                        {
                            fileModel.FileName = d.FileName;
                            fileModel.FileSize = d.FileSize;
                            fileModel.FilePath = d.FilePath;
                            fileModel.FileExtension = d.FileExtension;
                        }
                        uploadedData.FilesList.Add(fileModel);
                    }
                    if(uploadedData.FilesList.Count > 0)
                    {
                        uploadedData.FilesListXml = Utilities.ConvertIntoListXml(uploadedData.FilesList);
                    }
                    uploadedDocuments.Add(uploadedData);
                    candidateFormInputModel.DocumentsList.Add(documentsList);
                    i++;
                }
                candidateFormInputModel.DocumentsXml = Utilities.ConvertIntoListXml(candidateFormInputModel.DocumentsList);
                if(uploadedDocuments.Count > 0)
                {
                    candidateFormInputModel.UploadedDocumentsXml = Utilities.ConvertIntoListXml(uploadedDocuments);
                }
            }
            if (candidateFormInputModel.UploadResume.Count > 0)
            {
                List<UploadDocList> uploadDocList = new List<UploadDocList>();
                List<UploadedData> uploadResume = new List<UploadedData>();
                var i = 0;
                foreach (var uploadResum in candidateFormInputModel.UploadResume)
                {
                    UploadDocList uploadDocLists = new UploadDocList();
                    uploadDocLists.Description = "Resume";
                    uploadDocLists.DocumentName = "Resume";
                    uploadDocLists.DocumentType = uploadResum.DocumentType;
                    UploadedData uploadedData = new UploadedData();
                    uploadedData.FilesList = new List<FileModel>();
                    foreach (var resume in uploadResum.Data)
                    {
                        FileModel fileModel = new FileModel();
                        
                            fileModel.FileName = resume.FileName;
                            fileModel.FileSize = resume.FileSize;
                            fileModel.FilePath = resume.FilePath;
                            fileModel.FileExtension = resume.FileExtension;
                        
                        uploadedData.FilesList.Add(fileModel);
                    }
                    if (uploadedData.FilesList.Count > 0)
                    {
                        uploadedData.FilesListXml = Utilities.ConvertIntoListXml(uploadedData.FilesList);
                    }
                    uploadResume.Add(uploadedData);
                    uploadDocList.Add(uploadDocLists);
                    i++;
                }
                candidateFormInputModel.ResumeXml = Utilities.ConvertIntoListXml(uploadDocList);
                if (uploadResume.Count > 0)
                {
                    candidateFormInputModel.UploadedResumeXml = uploadResume[0].FilesListXml;
                        
                }
            }
            candidateFormInputModel.JobOpeningId = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
            var uniqueNumber = _recruitmentRepository.UpsertCandidateFormSubmitted(candidateFormInputModel,genericformSubmittedUpsertInputModel, validationMessages);
            var splitValues = uniqueNumber.Split(',');
            //thread to send notification to Assigned manager and candidate when a new candidate is added
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {

                    if (genericformSubmittedUpsertInputModel != null && uniqueNumber != null)
                    {
                        CandidatesSearchOutputModel insertedNewCandidateModel = new CandidatesSearchOutputModel();
                        LoggedInContext loggedInContext = new LoggedInContext();
                        loggedInContext.CompanyGuid = new Guid(splitValues[2]);
                        loggedInContext.LoggedInUserId = new Guid(splitValues[3]);
                        var candidateId = new Guid(splitValues[1]);
                        insertedNewCandidateModel.CandidateId = candidateId;
                        insertedNewCandidateModel.JobOpeningId = candidateFormInputModel.JobOpeningId;
                        insertedNewCandidateModel.FirstName = candidateFormInputModel.FirstName;
                        insertedNewCandidateModel.LastName = candidateFormInputModel.LastName;
                        insertedNewCandidateModel.Email = candidateFormInputModel.Email;
                        insertedNewCandidateModel.CandidateUniqueName = splitValues[0];
                        BackgroundJob.Enqueue(() => SendCandidateAddedEmail(insertedNewCandidateModel, loggedInContext, validationMessages, true, true));
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateFormSubmitted", "RecruitmentService ", exception.Message), exception);
                }
            });

            return splitValues[0];
        }
        public Guid? HiredDocumentsList(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "HiredDocumentsList", "Recruitment Service"));
            //if (!RecruitmentValidationHelper.CandidateDocumentUpsertInputModel(candidateDocumentUpsertInputModel, loggedInContext, validationMessages))
            //{
            //    return null;
            //}
            
            //thread to send notification for Hired documents list to candidate
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {

                    if (candidateDocumentUpsertInputModel != null )
                    {
                       // CandidateDocumentUpsertInputModel insertedNewCandidateModel = new CandidateDocumentUpsertInputModel();
                        BackgroundJob.Enqueue(() => SendCandidateHiredDocumentsEmail(candidateDocumentUpsertInputModel, loggedInContext, validationMessages, true));
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                }
            });
            return candidateDocumentUpsertInputModel.CandidateDocumentsId;
        }
        public void SendCandidateHiredDocumentsEmail(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isCandidateCreation)
        {
            
           CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
            List<string> DocumentArray = candidateDocumentUpsertInputModel.DocumentArray;
            string DocumentName = string.Empty;

            DocumentName += "<ol style=\"text -align:start\">";

            foreach (var document in DocumentArray)
            {
                DocumentName += "<li>" + document + "</li>";
            }
            DocumentName += "</ol>";
            var html = _goalRepository.GetHtmlTemplateByName("HiredDocumentsEmailTemplate", loggedInContext.CompanyGuid);
            var formattedHtml = html.Replace("##CandidateName##", candidateDocumentUpsertInputModel.CandidateName).
                                     Replace("##CompanyName##", companyDetails.CompanyName).
                                     Replace("##Document##", DocumentName);
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = candidateDocumentUpsertInputModel.CandidateEmail.Split('\n'),
                HtmlContent = formattedHtml,
                Subject = "Required hiring documents - Notification",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);


        }

        public void SendCandidateAssignedToManagerEmail(CandidatesSearchOutputModel candidatesSearchOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isCandidateCreation)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = candidatesSearchOutputModel.AssignedToManagerId
                }, loggedInContext, validationMessages);

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var address = ConfigurationManager.AppSettings["SiteUrl"];
                var siteAddress = address + "/recruitment/candidate/" + candidatesSearchOutputModel.CandidateId + "/" + candidatesSearchOutputModel.JobOpeningId;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("CandidateAssignedToManagerEmail", loggedInContext.CompanyGuid);

                string operationPerformedByUser;

                if (isCandidateCreation)
                {
                    operationPerformedByUser = operationPerformedUserDetails[0].FirstName + " " +
                                               operationPerformedUserDetails[0].SurName;

                }
                else
                {
                    operationPerformedByUser = operationPerformedUserDetails[0].FirstName + " " +
                                               operationPerformedUserDetails[0].SurName + " updated";
                }

                string CandidateName = "Candidate";

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedByUser).
                    Replace("##CandidateName##", candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName).
                    Replace("##Candidate##", CandidateName).
                    Replace("##AssigneeName##", usersList[0].FirstName + " " + usersList[0].SurName).
                    Replace("##HiringManager##", usersList[0].FirstName + " " + usersList[0].SurName).
                    Replace("##CandidateRegistrationNumber##", candidatesSearchOutputModel.CandidateUniqueName).
                    Replace("##CandidateUniquePageLink##", siteAddress).Replace("##siteAddress##", siteAddress);

                if (isCandidateCreation)
                {

                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { usersList[0].Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: " + CandidateName + " " + candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName + " assigned",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);

                }
                else
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { usersList[0].Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: New " + CandidateName + " " + candidatesSearchOutputModel.FirstName + candidatesSearchOutputModel.LastName + " updated",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }
        }

        public void SendCandidateAddedEmail(CandidatesSearchOutputModel candidatesSearchOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isCandidateCreation, bool isRegisteredByCandidate = false)
        {
            List<UserOutputModel> operationPerformedUserDetails = new List<UserOutputModel>();
            if (!isRegisteredByCandidate)
            {
                    operationPerformedUserDetails = _userRepository.GetAllUsers(
                    new Models.User.UserSearchCriteriaInputModel
                    {
                        UserId = loggedInContext.LoggedInUserId
                    }, loggedInContext, validationMessages);
            }
            //List<UserOutputModel> usersList = _userRepository.GetAllUsers(
            //    new Models.User.UserSearchCriteriaInputModel
            //    {
            //        UserId = candidatesSearchOutputModel.AssignedToManagerId
            //    }, loggedInContext, validationMessages);

            if (candidatesSearchOutputModel.Email != null && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0 && !isRegisteredByCandidate)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var address = ConfigurationManager.AppSettings["SiteUrl"];
                var siteAddress = address + "/recruitment/candidate/" + candidatesSearchOutputModel.CandidateId + "/" + candidatesSearchOutputModel.JobOpeningId;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("CandidateCreationEmailTemplate", loggedInContext.CompanyGuid);

                string operationPerformedByUser;

                if (isCandidateCreation)
                {
                    operationPerformedByUser = operationPerformedUserDetails[0].FirstName + " " +
                                               operationPerformedUserDetails[0].SurName + " registered";

                }
                else
                {
                    operationPerformedByUser = operationPerformedUserDetails[0].FirstName + " " +
                                               operationPerformedUserDetails[0].SurName + " updated";
                }

                string CandidateName = "Candidate";

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedByUser).
                    Replace("##CandidateName##", candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName).
                    Replace("##Candidate##", CandidateName).
                    Replace("##CompanyName##", companyDetails.CompanyName).
                    Replace("##CandidateUniqueName##", candidatesSearchOutputModel.CandidateUniqueName).
                    Replace("##siteAddress##", siteAddress);

                if (isCandidateCreation)
                {

                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { candidatesSearchOutputModel.Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: " + " " + candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName + " You have successfully registered",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);

                }
                else
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { candidatesSearchOutputModel.Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: New " + CandidateName + " " + candidatesSearchOutputModel.FirstName + candidatesSearchOutputModel.LastName + " updated",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }

            else
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var address = ConfigurationManager.AppSettings["SiteUrl"];
                var siteAddress = address + "/recruitment/candidate/" + candidatesSearchOutputModel.CandidateId + "/" + candidatesSearchOutputModel.JobOpeningId;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("CandidateCreationEmailTemplate", loggedInContext.CompanyGuid);

                string CandidateName = "Candidate";

                var formattedHtml = html.Replace("##OperationPerformedUser##", "").
                    Replace("##CandidateName##", candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName).
                    Replace("##Candidate##", CandidateName).
                    Replace("##CompanyName##", companyDetails.CompanyName).
                    Replace("##CandidateUniqueName##", candidatesSearchOutputModel.CandidateUniqueName).
                    Replace("##siteAddress##", siteAddress);

                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { candidatesSearchOutputModel.Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: " + " " + candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName + " You have successfully registered",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public List<CandidatesSearchOutputModel> GetCandidates(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidates", "Recruitment Service"));
            LoggingManager.Debug(candidatesSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidatesCommandId, candidatesSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidatesSearchOutputModel> candidates = _recruitmentRepository.GetCandidates(candidatesSearchInputModel, loggedInContext, validationMessages).ToList();
            return candidates;
        }

        public List<CandidatesSearchOutputModel> GetCandidatesBySkill(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidatesBySkill", "Recruitment Service"));
            LoggingManager.Debug(candidatesSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidatesCommandId, candidatesSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidatesSearchOutputModel> candidates = _recruitmentRepository.GetCandidatesBySkill(candidatesSearchInputModel, loggedInContext, validationMessages).ToList();
            return candidates;
        }
        public List<CandidateSkillsSearchOutputModel> GetSkillsByCandidates(CandidateSkillsSearchInputModel candidateSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSkillsByCandidates", "Recruitment Service"));
            //LoggingManager.Debug(candidateSkillsSearchInputModel.ToString());
            //_auditService.SaveAudit(AppCommandConstants.GetCandidatesCommandId, candidateSkillsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateSkillsSearchOutputModel> CandidateSkillId = _recruitmentRepository.GetSkillsByCandidates(candidateSkillsSearchInputModel, loggedInContext, validationMessages).ToList();
            return CandidateSkillId;
        }
        public List<CandidateHistorySearchOutputModel> GetCandidateHistory(CandidateHistorySearchInputModel candidateHistorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateHistory", "Recruitment Service"));
            LoggingManager.Debug(candidateHistorySearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidatesCommandId, candidateHistorySearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateHistorySearchOutputModel> candidateHistory = _recruitmentRepository.GetCandidateHistory(candidateHistorySearchInputModel, loggedInContext, validationMessages).ToList();
            return candidateHistory;
        }

        public Guid? UpsertJobOpening(JobOpeningUpsertInputModel jobOpeningUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Job Opening", "Recruitment Service"));
            LoggingManager.Debug(jobOpeningUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertJobOpeningCommandId, jobOpeningUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.JobOpeningUpsertInputModel(jobOpeningUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (jobOpeningUpsertInputModel.JobOpeningId == Guid.Empty || jobOpeningUpsertInputModel.JobOpeningId == null)
            {
                jobOpeningUpsertInputModel.JobOpeningId = _recruitmentRepository.UpsertJobOpening(jobOpeningUpsertInputModel, loggedInContext, validationMessages);

                JobOpeningsSearchInputModel jobOpeningsSearchInputModel = new JobOpeningsSearchInputModel
                {
                    JobOpeningTitle = jobOpeningUpsertInputModel.JobOpeningTitle
                };

                //notification for new Jobopening
                if (jobOpeningUpsertInputModel.JobOpeningId != null && jobOpeningUpsertInputModel.JobOpeningId != Guid.Empty)
                {
                    jobOpeningsSearchInputModel.JobOpeningId = jobOpeningUpsertInputModel.JobOpeningId;

                    //thread to send notification to job opening manager when a new job opening is created
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        try
                        {
                            List<JobOpeningsSearchOutputModel> insertedNewJobOpeningModel =
                        _recruitmentRepository.GetJobOpenings(new JobOpeningsSearchInputModel
                        {
                            JobOpeningId = jobOpeningsSearchInputModel.JobOpeningId
                        }, loggedInContext,
                            validationMessages);

                            if (insertedNewJobOpeningModel != null && insertedNewJobOpeningModel[0].HiringManagerId != loggedInContext.LoggedInUserId)
                            {
                                BackgroundJob.Enqueue(() =>
                                SendJobOpeningCreationEmail(insertedNewJobOpeningModel[0], loggedInContext, validationMessages, true)
                            )
                            ;
                            }
                        }
                        catch (Exception exception)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                        }
                    });
                }
            }
            else
            {
                JobOpeningsSearchInputModel jobOpeningsSearchInputModel = new JobOpeningsSearchInputModel
                {
                    JobOpeningId = jobOpeningUpsertInputModel.JobOpeningId
                };
                List<JobOpeningsSearchOutputModel> OldjobOpeningModel = _recruitmentRepository.GetJobOpenings(jobOpeningsSearchInputModel, loggedInContext, validationMessages).ToList();
                jobOpeningUpsertInputModel.JobOpeningId = _recruitmentRepository.UpsertJobOpening(jobOpeningUpsertInputModel, loggedInContext, validationMessages);

                if (OldjobOpeningModel[0].HiringManagerId != jobOpeningUpsertInputModel.HiringManagerId)
                {
                    if (jobOpeningUpsertInputModel.JobOpeningId != null && jobOpeningUpsertInputModel.JobOpeningId != Guid.Empty)
                    {
                        jobOpeningsSearchInputModel.JobOpeningId = jobOpeningUpsertInputModel.JobOpeningId;

                        //thread to send notification to job opening manager when a new job opening is created
                        TaskWrapper.ExecuteFunctionInNewThread(() =>
                        {
                            try
                            {
                                List<JobOpeningsSearchOutputModel> insertedNewJobOpeningModel =
                            _recruitmentRepository.GetJobOpenings(new JobOpeningsSearchInputModel
                            {
                                JobOpeningId = jobOpeningsSearchInputModel.JobOpeningId
                            }, loggedInContext,
                                validationMessages);

                                if (insertedNewJobOpeningModel != null && insertedNewJobOpeningModel[0].HiringManagerId != loggedInContext.LoggedInUserId)
                                {
                                    BackgroundJob.Enqueue(() =>
                                    SendJobOpeningCreationEmail(insertedNewJobOpeningModel[0], loggedInContext, validationMessages, true)
                                        )
                                        ;
                                }
                            }
                            catch (Exception exception)
                            {
                                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                            }
                        });
                    }
                }
            }
            return jobOpeningUpsertInputModel.JobOpeningId;
        }

        public void SendJobOpeningCreationEmail(JobOpeningsSearchOutputModel jobOpeningsSearchOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isJobCreation)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = jobOpeningsSearchOutputModel.HiringManagerId
                }, loggedInContext, validationMessages);

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var address = ConfigurationManager.AppSettings["SiteUrl"];
                var siteAddress = address + "/recruitment/jobopening/" + jobOpeningsSearchOutputModel.JobOpeningId;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("JobOpeningEmailTemplate", loggedInContext.CompanyGuid);

                string operationPerformedByUser;

                if (isJobCreation)
                {
                    operationPerformedByUser = operationPerformedUserDetails[0].FirstName + " " +
                                               operationPerformedUserDetails[0].SurName + " assigned";

                }
                else
                {
                    operationPerformedByUser = operationPerformedUserDetails[0].FirstName + " " +
                                               operationPerformedUserDetails[0].SurName + " updated";
                }

                string jobOpeningName = "Job";
                string NoOfOpenings = Convert.ToString(jobOpeningsSearchOutputModel.NoOfOpenings);
                var formattedHtml = html.Replace("##HiringManager##", usersList[0].FirstName + " " + usersList[0].SurName).
                    Replace("##JobOpeningName##", jobOpeningsSearchOutputModel.JobOpeningTitle).
                    Replace("##JobOpening##", jobOpeningName).
                    Replace("##operationPerformedByUser##", operationPerformedByUser).
                    Replace("##DateFrom##", jobOpeningName).
                    Replace("##DateTo##", jobOpeningName).
                    Replace("##NoOfOpenings##", NoOfOpenings).
                    Replace("##siteAddress##", siteAddress);

                if (isJobCreation)
                {

                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { usersList[0].Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: " + jobOpeningName + " " + jobOpeningsSearchOutputModel.JobOpeningTitle + " assigned",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };

                    _emailService.SendMail(loggedInContext, emailModel);

                }
                else
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { usersList[0].Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: New " + jobOpeningName + " " + jobOpeningsSearchOutputModel.JobOpeningTitle + " updated",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }
        }

        public List<JobOpeningsSearchOutputModel> GetJobOpenings(JobOpeningsSearchInputModel jobOpeningsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Job Openings", "Recruitment Service"));
            LoggingManager.Debug(jobOpeningsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetJobOpeningsCommandId, jobOpeningsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<JobOpeningsSearchOutputModel> jobOpenings = _recruitmentRepository.GetJobOpenings(jobOpeningsSearchInputModel, loggedInContext, validationMessages).ToList();
            return jobOpenings;
        }

        public List<BrytumViewJobDetailsOutputModel> GetBrytumViewJobDetails(JobOpeningsSearchInputModel jobOpeningsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBrytumViewJobDetails", "Recruitment Service"));

            LoggingManager.Debug(jobOpeningsSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetJobOpeningsCommandId, jobOpeningsSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<BrytumViewJobDetailsOutputModel> jobOpenings = _recruitmentRepository.GetBrytumViewJobDetails(jobOpeningsSearchInputModel, loggedInContext, validationMessages).ToList();

            return jobOpenings;
        }

        public Guid? UpsertJobOpeningSkill(JobOpeningSkillUpsertInputModel jobOpeningSkillUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Job Opening Skill", "Recruitment Service"));
            LoggingManager.Debug(jobOpeningSkillUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertJobOpeningSkillCommandId, jobOpeningSkillUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.JobOpeningSkillUpsertInputModel(jobOpeningSkillUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            jobOpeningSkillUpsertInputModel.JobOpeningId = _recruitmentRepository.UpsertJobOpeningSkill(jobOpeningSkillUpsertInputModel, loggedInContext, validationMessages);
            return jobOpeningSkillUpsertInputModel.JobOpeningId;
        }

        public List<JobOpeningSkillsSearchOutputModel> GetJobOpeningSkills(JobOpeningSkillsSearchInputModel jobOpeningSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get JobOpening Skills", "Recruitment Service"));
            LoggingManager.Debug(jobOpeningSkillsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetJobOpeningSkillsCommandId, jobOpeningSkillsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<JobOpeningSkillsSearchOutputModel> jobOpeningSkills = _recruitmentRepository.GetJobOpeningSkills(jobOpeningSkillsSearchInputModel, loggedInContext, validationMessages).ToList();
            return jobOpeningSkills;
        }
        public Guid? UpsertCandidateSkill(CandidateSkillUpsertInputModel candidateSkillUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateSkill", "Recruitment Service"));
            LoggingManager.Debug(candidateSkillUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateSkillCommandId, candidateSkillUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateSkillUpsertInputModel(candidateSkillUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            candidateSkillUpsertInputModel.CandidateSkillId = _recruitmentRepository.UpsertCandidateSkill(candidateSkillUpsertInputModel, loggedInContext, validationMessages);
            return candidateSkillUpsertInputModel.CandidateSkillId;
        }

        public List<CandidateSkillsSearchOutputModel> GetCandidateSkills(CandidateSkillsSearchInputModel candidateSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateSkills", "Recruitment Service"));
            LoggingManager.Debug(candidateSkillsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidateSkillsCommandId, candidateSkillsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateSkillsSearchOutputModel> CandidateSkills = _recruitmentRepository.GetCandidateSkills(candidateSkillsSearchInputModel, loggedInContext, validationMessages).ToList();
            return CandidateSkills;
        }

        public Guid? UpsertCandidateExperience(CandidateExperienceUpsertInputModel candidateExperienceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateExperience", "Recruitment Service"));
            LoggingManager.Debug(candidateExperienceUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateExperienceCommandId, candidateExperienceUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateExperirenceUpsertInputModel(candidateExperienceUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            candidateExperienceUpsertInputModel.CandidateExperienceDetailsId = _recruitmentRepository.UpsertCandidateExperience(candidateExperienceUpsertInputModel, loggedInContext, validationMessages);
            return candidateExperienceUpsertInputModel.CandidateExperienceDetailsId;
        }

        public List<CandidateExperienceSearchOutputModel> GetCandidateExperience(CandidateExperienceSearchInputModel candidateExperienceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateExperience", "Recruitment Service"));
            LoggingManager.Debug(candidateExperienceSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidateExperienceCommandId, candidateExperienceSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateExperienceSearchOutputModel> CandidateExperience = _recruitmentRepository.GetCandidateExperiences(candidateExperienceSearchInputModel, loggedInContext, validationMessages).ToList();
            return CandidateExperience;
        }

        public Guid? UpsertCandidateEducation(CandidateEducationUpsertInputModel candidateEducationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateEducation", "Recruitment Service"));
            LoggingManager.Debug(candidateEducationUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateEducationCommandId, candidateEducationUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateEducationUpsertInputModel(candidateEducationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            candidateEducationUpsertInputModel.CandidateEducationalDetailId = _recruitmentRepository.UpsertCandidateEducation(candidateEducationUpsertInputModel, loggedInContext, validationMessages);
            return candidateEducationUpsertInputModel.CandidateEducationalDetailId;
        }

        public List<CandidateEducationSearchOutputModel> GetCandidateEducation(CandidateEducationSearchInputModel candidateEducationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateEducation", "Recruitment Service"));
            LoggingManager.Debug(candidateEducationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidateEducationCommandId, candidateEducationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateEducationSearchOutputModel> CandidateEducation = _recruitmentRepository.GetCandidateEducation(candidateEducationSearchInputModel, loggedInContext, validationMessages).ToList();
            return CandidateEducation;
        }

        public List<JobOpeningsSearchOutputModel> GetCandidateJobOpenings(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateEducation", "Recruitment Service"));
            LoggingManager.Debug(candidatesSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetJobOpeningsCommandId, candidatesSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<JobOpeningsSearchOutputModel> CandidateJobOpenings = _recruitmentRepository.GetCandidateJobOpenings(candidatesSearchInputModel, loggedInContext, validationMessages).ToList();
            return CandidateJobOpenings;
        }

        public Guid? UpsertCandidateDocument(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateDocument", "Recruitment Service"));
            LoggingManager.Debug(candidateDocumentUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateDocumentCommandId, candidateDocumentUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateDocumentUpsertInputModel(candidateDocumentUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            candidateDocumentUpsertInputModel.CandidateDocumentsId = _recruitmentRepository.UpsertCandidateDocument(candidateDocumentUpsertInputModel, loggedInContext, validationMessages);
            return candidateDocumentUpsertInputModel.CandidateDocumentsId;
        }

        public List<CandidateDocumentsSearchOutputModel> GetCandidateDocuments(CandidateDocumentsSearchInputModel candidateDocumentsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateDocuments", "Recruitment Service"));
            LoggingManager.Debug(candidateDocumentsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidateDocumentsCommandId, candidateDocumentsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateDocumentsSearchOutputModel> CandidateDocuments = _recruitmentRepository.GetCandidateDocuments(candidateDocumentsSearchInputModel, loggedInContext, validationMessages).ToList();
            return CandidateDocuments;
        }

        public Guid? UpsertInterviewProcess(InterviewProcessUpsertInputModel interviewProcessUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewProcess", "Recruitment Service"));
            LoggingManager.Debug(interviewProcessUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertInterviewProcessCommandId, interviewProcessUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.InterviewProcessUpsertInputModel(interviewProcessUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (interviewProcessUpsertInputModel.InterviewTypeId?.Count > 0 && interviewProcessUpsertInputModel.InterviewTypeId != null)
            {
                interviewProcessUpsertInputModel.InterviewTypeIds = Utilities.ConvertIntoListXml(interviewProcessUpsertInputModel.InterviewTypeId);
            }

            interviewProcessUpsertInputModel.InterviewProcessId = _recruitmentRepository.UpsertInterviewProcess(interviewProcessUpsertInputModel, loggedInContext, validationMessages);
            return interviewProcessUpsertInputModel.InterviewProcessId;
        }

        public List<InterviewProcessSearchOutputModel> GetInterviewprocess(InterviewProcessSearchInputModel interviewProcessSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewprocess", "Recruitment Service"));
            LoggingManager.Debug(interviewProcessSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetInterviewProcessCommandId, interviewProcessSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<InterviewProcessSearchOutputModel> interviewProcess = _recruitmentRepository.GetInterviewProcess(interviewProcessSearchInputModel, loggedInContext, validationMessages).ToList();
            return interviewProcess;
        }

        public Guid? UpsertInterviewProcessConfiguration(InterviewProcessConfigurationUpsertInputModel interviewProcessConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewProcessConfiguration", "Recruitment Service"));
            LoggingManager.Debug(interviewProcessConfigurationUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertInterviewProcessConfigurationCommandId, interviewProcessConfigurationUpsertInputModel, loggedInContext);
            if (interviewProcessConfigurationUpsertInputModel.interviewProcessConfigurationIds != null && interviewProcessConfigurationUpsertInputModel.interviewProcessConfigurationIds.Count > 0)
            {
                interviewProcessConfigurationUpsertInputModel.interviewProcessConfigurationIdsXml = Utilities.ConvertIntoListXml(interviewProcessConfigurationUpsertInputModel.interviewProcessConfigurationIds);
            }
            if (!RecruitmentValidationHelper.InterviewProcessConfigurationUpsertInputModel(interviewProcessConfigurationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            interviewProcessConfigurationUpsertInputModel.InterviewProcessConfigurationId = _recruitmentRepository.UpsertInterviewProcessConfiguration(interviewProcessConfigurationUpsertInputModel, loggedInContext, validationMessages);

            return interviewProcessConfigurationUpsertInputModel.InterviewProcessConfigurationId;
        }

        public void SendInterviewStatusChangeEmail(CandidatesSearchOutputModel candidatesSearchOutputModel, Guid? InterviewTypeId, Guid? StatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isForCandidate)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = candidatesSearchOutputModel.AssignedToManagerId
                }, loggedInContext, validationMessages);

            List<InterviewTypesSearchOutputModel> interviewTypes =
                _recruitmentMasterDataService.GetInterviewTypes(
                    new InterviewTypesSearchInputModel
                    {
                        InterviewTypeId = InterviewTypeId
                    }, loggedInContext, validationMessages);


            List<ScheduleStatusSearchOutputModel> ScheduleStatus =
            _recruitmentMasterDataService.GetScheduleStatus(
                new ScheduleStatusSearchInputModel
                {
                    ScheduleStatusId = StatusId
                }, loggedInContext, validationMessages);

            if (candidatesSearchOutputModel.Email != null && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/recruitment/candidate/" + candidatesSearchOutputModel.CandidateId;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var html = _goalRepository.GetHtmlTemplateByName("InterviewStatusChangeEmail", loggedInContext.CompanyGuid);

                string statusMessage = "";
                string dearMessage = "";
                string headerMessage = "";
                if (isForCandidate)
                {
                    headerMessage = interviewTypes[0].InterviewTypeName + " Round Feedback / Comments";
                    dearMessage = "Dear " + candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName + " Your Last Round Status";
                    statusMessage = "Thank you so much for your interest in recruitment process with us. While we were impressed with your skill set, we have chosen to proceed with another candidate(s) who has more more skill set. Again, we appreciate your time, and we wish you the best of luck in your career endeavors.";
                    if (ScheduleStatus[0].Status == "Selected")
                    {
                        statusMessage = "Thank you for taking the time to speak with us in round, We’re quite impressed by you and are eager to continue the conversation! We’d like to schedule next interview with you during schedule timings. We will intimate schedule timings in soon.";
                    }
                }
                else
                {
                    headerMessage = candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName + "'s " + interviewTypes[0].InterviewTypeName + " Round Feedback / Comments";
                    dearMessage = "Dear " + usersList[0].FirstName + " " + usersList[0].SurName + "," + candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName + "'s" + " Last Round Status";
                    statusMessage = "Thank you for taking the time to interview with us,  While we were impressed with candidate skill set, we have chosen to proceed with another candidate(s) who has more more skill set.";
                    if (ScheduleStatus[0].Status == "Selected")
                    {
                        statusMessage = "Thank you for taking the time to interview with us, We’re quite impressed by the candidate and we are eager to continue the conversation! We’d like to schedule next interview with you during schedule timings. We will intimate schedule timings in soon.";
                    }
                }

                //List<InterviewProcessConfigurationSearchOutputModel> interviewProcessConfiguration = 
                //    _recruitmentRepository.GetInterviewProcessConfiguration(
                //        new InterviewProcessConfigurationSearchInputModel
                //        { CandidateId= candidatesSearchOutputModel.CandidateId,
                //        JobOpeningId = candidatesSearchOutputModel.JobOpeningId,
                //        InterviewProcessId = candidatesSearchOutputModel.InterviewProcessId
                //        }, loggedInContext, validationMessages).ToList();

                //var interviewStatusHistory = interviewProcessConfiguration[0];
                //var interviewStatuses = interviewStatusHistory.StatusName;

                //string interviewStatusHistoryView = string.Empty;

                //interviewStatusHistoryView += "<center><table border=\"1\" style=\"height: 200px; width: 500px\">";
                //interviewStatusHistoryView += "<tr><th style=\"paddind:8px\"><center>Round name</center></th>";
                //interviewStatusHistoryView += "<th style=\"paddind:8px\"><center>" + "Status </center></th>";
                //int i = 1;
                //foreach (var history in interviewProcessConfiguration)
                //{
                //        interviewStatusHistoryView += "<tr><td style=\"paddind:8px\"><center>" + history.InterviewTypeName + "</center></td>";
                //        interviewStatusHistoryView += "<td style=\"paddind:8px\"><center>" + history.StatusName + "</center></td>";

                //}
                //interviewStatusHistoryView += "</table><center>";
                string CandidateName = "Candidate";

                var formattedHtml = html.Replace("##CandidateName##", candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName).
                    Replace("##Candidate##", CandidateName).
                    Replace("##Status##", ScheduleStatus[0].Status).
                    Replace("##DearMessage##", dearMessage).
                    Replace("##HeaderMessage##", headerMessage).
                    Replace("##statusMessage##", statusMessage).
                    Replace("##RoundName##", interviewTypes[0].InterviewTypeName);

                if (isForCandidate)
                {

                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { candidatesSearchOutputModel.Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: " + CandidateName + " " + candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName + " Interview Status",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);

                }
                else
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = new[] { usersList[0].Email },
                        HtmlContent = formattedHtml,
                        Subject = "Snovasys Business Suite: " + CandidateName + " " + candidatesSearchOutputModel.FirstName + " " + candidatesSearchOutputModel.LastName + " Interview Status",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }
        }

        public List<InterviewProcessConfigurationSearchOutputModel> GetInterviewprocessConfiguration(InterviewProcessConfigurationSearchInputModel interviewProcessConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewprocessConfiguration", "Recruitment Service"));
            LoggingManager.Debug(interviewProcessConfigurationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetInterviewProcessConfigurationCommandId, interviewProcessConfigurationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<InterviewProcessConfigurationSearchOutputModel> interviewProcessConfiguration = _recruitmentRepository.GetInterviewProcessConfiguration(interviewProcessConfigurationSearchInputModel, loggedInContext, validationMessages).ToList();
            return interviewProcessConfiguration;
        }

        public Guid? ApproveCandidateInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ApproveCandidateInterviewSchedule", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewScheduleUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateInterviewScheduleCommandId, candidateInterviewScheduleUpsertInputModel, loggedInContext);
            var jobOpeningId = candidateInterviewScheduleUpsertInputModel.JobOpeningId;
            var candidateId = candidateInterviewScheduleUpsertInputModel.CandidateId;


            candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId = _recruitmentRepository.ApproveCandidateInterviewSchedule(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages);

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {
                    var scheduleAssigneeDetails = GetScheduleAssigneeDetails(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages);
                    var pendingScheduleApproval = scheduleAssigneeDetails.FindAll(x => (x.IsApproved == false || x.IsApproved == null)).ToList();
                    if(pendingScheduleApproval.Count() == 0)
                    {
                        scheduleAssigneeDetails.ForEach(x =>
                        {
                            if (x.UserName != null)
                            {
                                candidateInterviewScheduleUpsertInputModel.EmailAddress = x.UserName;
                                candidateInterviewScheduleUpsertInputModel.Name = x.AssignToUserName;
                                candidateInterviewScheduleUpsertInputModel.InterviewDate = x.InterviewDate;
                                candidateInterviewScheduleUpsertInputModel.StartTime = x.StartTime;
                                candidateInterviewScheduleUpsertInputModel.EndTime = x.EndTime;
                                candidateInterviewScheduleUpsertInputModel.InterviewTypeName = x.InterviewTypeName;
                                candidateInterviewScheduleUpsertInputModel.IsVideoCalling = x.IsVideoCalling;
                                candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId = x.CandidateInterviewScheduleId;
                                BackgroundJob.Enqueue(() =>
                                CandidateInterviewScheduleConfirmedMail(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages));
                            }
                        });

                        List<CandidatesSearchOutputModel> CandidateModel =
                                _recruitmentRepository.GetCandidates(new CandidatesSearchInputModel
                                {
                                    CandidateId = candidateId,
                                    JobOpeningId = jobOpeningId
                                }, loggedInContext,
                                    validationMessages);

                        candidateInterviewScheduleUpsertInputModel.EmailAddress = CandidateModel[0].Email;
                        candidateInterviewScheduleUpsertInputModel.Name = CandidateModel[0].FirstName + ' ' + CandidateModel[0].LastName;
                        candidateInterviewScheduleUpsertInputModel.InterviewDate = scheduleAssigneeDetails[0].InterviewDate;
                        candidateInterviewScheduleUpsertInputModel.StartTime = scheduleAssigneeDetails[0].StartTime;
                        candidateInterviewScheduleUpsertInputModel.EndTime = scheduleAssigneeDetails[0].EndTime;
                        candidateInterviewScheduleUpsertInputModel.InterviewTypeName = scheduleAssigneeDetails[0].InterviewTypeName;
                        candidateInterviewScheduleUpsertInputModel.IsVideoCalling = scheduleAssigneeDetails[0].IsVideoCalling;
                        candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId = scheduleAssigneeDetails[0].CandidateInterviewScheduleId;
                        BackgroundJob.Enqueue(() =>
                                CandidateInterviewScheduleConfirmedMail(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages));
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ApproveCandidateInterviewSchedule", "Recrruitment service ", exception.Message), exception);

                }
            });
            return candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId;
        }

        public Guid? UpsertCandidateInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateInterviewSchedule", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewScheduleUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateInterviewScheduleCommandId, candidateInterviewScheduleUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateInterviewScheduleUpsertInputModel(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);

            if (candidateInterviewScheduleUpsertInputModel.StartTime != null && candidateInterviewScheduleUpsertInputModel.StartTime != "")
            {
                DateTime? date1 = candidateInterviewScheduleUpsertInputModel.InterviewDate + TimeSpan.Parse(candidateInterviewScheduleUpsertInputModel.StartTime);

                candidateInterviewScheduleUpsertInputModel.StartDateTime = DateTimeOffset.ParseExact(date1.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + userTimeDetails.GMTOffset,
                                               "yyyy-MM-dd'T'HH:mm:sszzz",
                                               CultureInfo.InvariantCulture);
            }

            if (candidateInterviewScheduleUpsertInputModel.EndTime != null && candidateInterviewScheduleUpsertInputModel.EndTime != "")
            {
                DateTime? date2 = candidateInterviewScheduleUpsertInputModel.InterviewDate +
                TimeSpan.Parse(candidateInterviewScheduleUpsertInputModel.EndTime);

                candidateInterviewScheduleUpsertInputModel.EndDateTime = DateTimeOffset.ParseExact(date2.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + userTimeDetails.GMTOffset,
                                                "yyyy-MM-dd'T'HH:mm:sszzz",
                                                CultureInfo.InvariantCulture);
            }

            if (candidateInterviewScheduleUpsertInputModel.Assignee != null && candidateInterviewScheduleUpsertInputModel.Assignee.Count > 0)
            {
                candidateInterviewScheduleUpsertInputModel.AssigneeIds = string.Join(",", candidateInterviewScheduleUpsertInputModel.Assignee);
            }
            
            candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId = _recruitmentRepository.UpsertCandidateInterviewSchedule(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages);

            List<ScheduleStatusSearchOutputModel> ScheduleStatus =
            _recruitmentMasterDataService.GetScheduleStatus(
                new ScheduleStatusSearchInputModel
                {
                    ScheduleStatusId = candidateInterviewScheduleUpsertInputModel.StatusId
                }, loggedInContext, validationMessages);

            if((candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId != null && (candidateInterviewScheduleUpsertInputModel.StatusId == null || candidateInterviewScheduleUpsertInputModel.StatusId.ToString().Equals("00000000-0000-0000-0000-000000000000"))) || (candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId != null && candidateInterviewScheduleUpsertInputModel.IsRescheduled == true))
            {
                var isRescheduled = candidateInterviewScheduleUpsertInputModel.IsRescheduled;
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {
                        var scheduleAssigneeDetails = GetScheduleAssigneeDetails(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages);
                        scheduleAssigneeDetails.ForEach(x =>
                        {
                            if (x.UserName != null)
                            {
                                candidateInterviewScheduleUpsertInputModel.EmailAddress = x.UserName;
                                candidateInterviewScheduleUpsertInputModel.Name = x.AssignToUserName;
                                candidateInterviewScheduleUpsertInputModel.InterviewDate = x.InterviewDate;
                                candidateInterviewScheduleUpsertInputModel.StartTime = x.StartTime;
                                candidateInterviewScheduleUpsertInputModel.EndTime = x.EndTime; candidateInterviewScheduleUpsertInputModel.InterviewTypeName = x.InterviewTypeName;
                                BackgroundJob.Enqueue(() =>
                                        AssigneeInterviewScheduleApprovalEmail(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages, isRescheduled)
                                    );
                            }
                        });
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateInterviewSchedule", "UpsertCandidateInterviewSchedule ", exception.Message), exception);

                    }
                });
            }

            List<CandidatesSearchOutputModel> CandidateModel =
                              _recruitmentRepository.GetCandidates(new CandidatesSearchInputModel
                              {
                                  CandidateId = candidateInterviewScheduleUpsertInputModel.CandidateId,
                                  JobOpeningId = candidateInterviewScheduleUpsertInputModel.JobOpeningId
                              }, loggedInContext,
                                  validationMessages);

            if (candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId != null && candidateInterviewScheduleUpsertInputModel.StatusId != null && ((ScheduleStatus[0].Status == "Selected") || (ScheduleStatus[0].Status == "Not selected")))
            {

                //thread to send notification to job opening manager when a new job opening is created
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {


                        if (CandidateModel != null && CandidateModel[0].AssignedToManagerId != loggedInContext.LoggedInUserId)
                        {
                            BackgroundJob.Enqueue(() =>
                            SendInterviewStatusChangeEmail(CandidateModel[0], candidateInterviewScheduleUpsertInputModel.InterviewTypeId, candidateInterviewScheduleUpsertInputModel.StatusId, loggedInContext, validationMessages, true)
                        )
                        ;
                        }
                        var candidateAssignedManager = CandidateModel[0].AssignedToManagerId;
                        var scheduleAssigneeDetails = GetScheduleAssigneeDetails(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages);
                        scheduleAssigneeDetails.ForEach(x =>
                        {
                            if (x.UserName != null)
                            {
                                CandidateModel[0].AssignedToManagerId = x.AssignToUserId;
                                BackgroundJob.Enqueue(() =>
                            SendInterviewStatusChangeEmail(CandidateModel[0], candidateInterviewScheduleUpsertInputModel.InterviewTypeId, candidateInterviewScheduleUpsertInputModel.StatusId, loggedInContext, validationMessages, true));
                            }
                        });

                        CandidateModel[0].AssignedToManagerId = candidateAssignedManager;

                        if (CandidateModel != null && CandidateModel[0].CandidateId != loggedInContext.LoggedInUserId)
                        {
                            BackgroundJob.Enqueue(() =>
                            SendInterviewStatusChangeEmail(CandidateModel[0], candidateInterviewScheduleUpsertInputModel.InterviewTypeId, candidateInterviewScheduleUpsertInputModel.StatusId, loggedInContext, validationMessages, false)
                        )
                        ;
                        }
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                    }
                });
            }
            
            return candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId;
        }

        public void ReccurInterviewSchedule()
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {

                    List<CandidateInterviewScheduleSearchOutputModel> scheduleCandidateDetails = _recruitmentRepository.ReccurInterviewScheduleOfCandidates(validationMessages, true);

                    scheduleCandidateDetails.ForEach(x =>
                    {
                        if (x.UserName != null)
                        {
                            CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel = new CandidateInterviewScheduleUpsertInputModel();
                            candidateInterviewScheduleUpsertInputModel.EmailAddress = x.UserName;
                            candidateInterviewScheduleUpsertInputModel.InterviewDate = x.InterviewDate;
                            candidateInterviewScheduleUpsertInputModel.StartTime = x.StartTime;
                            candidateInterviewScheduleUpsertInputModel.EndTime = x.EndTime;
                            candidateInterviewScheduleUpsertInputModel.Name = x.CandidateName;
                            candidateInterviewScheduleUpsertInputModel.InterviewTypeName = x.InterviewTypeName;
                            candidateInterviewScheduleUpsertInputModel.CandidateName = x.CandidateName;
                            candidateInterviewScheduleUpsertInputModel.AssignToUserId = x.AssignToUserId;
                            candidateInterviewScheduleUpsertInputModel.CompanyId = x.CompanyId;
                            candidateInterviewScheduleUpsertInputModel.IsVideoCalling = x.IsVideoCalling;
                            candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId = x.CandidateInterviewScheduleId;
                            var names = candidateInterviewScheduleUpsertInputModel.CandidateName.Split(' ');
                            var roomName = candidateInterviewScheduleUpsertInputModel.InterviewTypeName + "" + candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId.ToString() + "" + names[0];
                            var address = ConfigurationManager.AppSettings["SiteUrl"];
                            var url = address + "/application/joincall/" + roomName + "/" + candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId;
                            RoomDetailsModel roomDetails = new RoomDetailsModel();
                            roomDetails.Name = roomName;
                            roomDetails.ReceiverId = candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId;
                            roomDetails.CompanyId = candidateInterviewScheduleUpsertInputModel.CompanyId;
                            LoggedInContext loggedInContext = new LoggedInContext();
                            loggedInContext.LoggedInUserId = new Guid(candidateInterviewScheduleUpsertInputModel.AssignToUserId.ToString());
                            loggedInContext.CompanyGuid = new Guid(candidateInterviewScheduleUpsertInputModel.CompanyId.ToString());
                            BackgroundJob.Enqueue(() =>
                            SendScheduleRemainderEmails(candidateInterviewScheduleUpsertInputModel, true, x.CompanyId.ToString(), true));
                            _twilioWrapperClientService.CreateRoom(roomDetails, loggedInContext, validationMessages);
                        }
                    });

                    List<CandidateInterviewScheduleSearchOutputModel> scheduleAssigneeDetails = _recruitmentRepository.ReccurInterviewSchedule(validationMessages, true);

                    scheduleAssigneeDetails.ForEach(x =>
                    {
                        if (x.UserName != null)
                        {
                            CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel = new CandidateInterviewScheduleUpsertInputModel();
                            candidateInterviewScheduleUpsertInputModel.EmailAddress = x.UserName;
                            candidateInterviewScheduleUpsertInputModel.InterviewDate = x.InterviewDate;
                            candidateInterviewScheduleUpsertInputModel.StartTime = x.StartTime;
                            candidateInterviewScheduleUpsertInputModel.EndTime = x.EndTime;
                            candidateInterviewScheduleUpsertInputModel.Name = x.AssignToUserName;
                            candidateInterviewScheduleUpsertInputModel.InterviewTypeName = x.InterviewTypeName;
                            candidateInterviewScheduleUpsertInputModel.CandidateName = x.CandidateName;
                            candidateInterviewScheduleUpsertInputModel.AssignToUserId = x.AssignToUserId;
                            candidateInterviewScheduleUpsertInputModel.CompanyId = x.CompanyId;
                            candidateInterviewScheduleUpsertInputModel.IsVideoCalling = x.IsVideoCalling;
                            candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId = x.CandidateInterviewScheduleId;
                            BackgroundJob.Enqueue(() =>
                            SendScheduleRemainderEmails(candidateInterviewScheduleUpsertInputModel, false, x.CompanyId.ToString(), true));
                        }
                    });

                    scheduleCandidateDetails = _recruitmentRepository.ReccurInterviewScheduleOfCandidates(validationMessages, false);

                    scheduleCandidateDetails.ForEach(x =>
                    {
                        if (x.UserName != null)
                        {
                            CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel = new CandidateInterviewScheduleUpsertInputModel();
                            candidateInterviewScheduleUpsertInputModel.EmailAddress = x.UserName;
                            candidateInterviewScheduleUpsertInputModel.InterviewDate = x.InterviewDate;
                            candidateInterviewScheduleUpsertInputModel.StartTime = x.StartTime;
                            candidateInterviewScheduleUpsertInputModel.EndTime = x.EndTime;
                            candidateInterviewScheduleUpsertInputModel.Name = x.CandidateName;
                            candidateInterviewScheduleUpsertInputModel.InterviewTypeName = x.InterviewTypeName;
                            candidateInterviewScheduleUpsertInputModel.CandidateName = x.CandidateName;
                            candidateInterviewScheduleUpsertInputModel.AssignToUserId = x.AssignToUserId;
                            candidateInterviewScheduleUpsertInputModel.CompanyId = x.CompanyId;
                            candidateInterviewScheduleUpsertInputModel.IsVideoCalling = x.IsVideoCalling;
                            candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId = x.CandidateInterviewScheduleId;
                            BackgroundJob.Enqueue(() =>
                        SendScheduleRemainderEmails(candidateInterviewScheduleUpsertInputModel, true, x.CompanyId.ToString(), false));
                        }
                    });

                    scheduleAssigneeDetails = _recruitmentRepository.ReccurInterviewSchedule(validationMessages, false);

                    scheduleAssigneeDetails.ForEach(x =>
                    {
                        if (x.UserName != null)
                        {
                            CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel = new CandidateInterviewScheduleUpsertInputModel();
                            candidateInterviewScheduleUpsertInputModel.EmailAddress = x.UserName;
                            candidateInterviewScheduleUpsertInputModel.InterviewDate = x.InterviewDate;
                            candidateInterviewScheduleUpsertInputModel.StartTime = x.StartTime;
                            candidateInterviewScheduleUpsertInputModel.EndTime = x.EndTime;
                            candidateInterviewScheduleUpsertInputModel.Name = x.AssignToUserName;
                            candidateInterviewScheduleUpsertInputModel.InterviewTypeName = x.InterviewTypeName;
                            candidateInterviewScheduleUpsertInputModel.CandidateName = x.CandidateName;
                            candidateInterviewScheduleUpsertInputModel.AssignToUserId = x.AssignToUserId;
                            candidateInterviewScheduleUpsertInputModel.CompanyId = x.CompanyId;
                            candidateInterviewScheduleUpsertInputModel.IsVideoCalling = x.IsVideoCalling;
                            candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId = x.CandidateInterviewScheduleId;
                            BackgroundJob.Enqueue(() =>
                        SendScheduleRemainderEmails(candidateInterviewScheduleUpsertInputModel, false, x.CompanyId.ToString(), false));
                        }
                    });
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                }
            });
        }

        public void SendCandidateScheduleRemainderEmail(CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel, LoggedInContext loggedInContext)
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            if (candidateInterviewScheduleUpsertInputModel.EmailAddress != null)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("CandidateScheduleRemainderTemplate", loggedInContext.CompanyGuid);
                string description;
                description = "You have been scheduled for the interview on the above mentioned date and time.";

                var formattedHtml = html.Replace("##AssigneeName##", candidateInterviewScheduleUpsertInputModel.Name).
                    Replace("##InterviewDate##", candidateInterviewScheduleUpsertInputModel.InterviewDate.ToString()).
                    Replace("##StartTime##", candidateInterviewScheduleUpsertInputModel.StartTime).
                    Replace("##Description##", description).
                    Replace("##InterviewRound##", candidateInterviewScheduleUpsertInputModel.InterviewTypeName);

                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { candidateInterviewScheduleUpsertInputModel.EmailAddress },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: Interview Schedule Remainder",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);

            }
        }

        //public void SendScheduleRemainderEmail(CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel, LoggedInContext loggedInContext)
        //{
        //    List<ValidationMessage> validationMessages = new List<ValidationMessage>();
        //    List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
        //        new Models.User.UserSearchCriteriaInputModel
        //        {
        //            UserId = loggedInContext.LoggedInUserId
        //        }, loggedInContext, validationMessages);
            
        //    if (candidateInterviewScheduleUpsertInputModel.EmailAddress != null )
        //    {
        //        CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

        //         SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
        //        var html = _goalRepository.GetHtmlTemplateByName("CandidateScheduleRemainderTemplate", loggedInContext.CompanyGuid);
        //        string description;
        //        description = "You have been assigned to conduct interview for the candidate of "+ candidateInterviewScheduleUpsertInputModel.CandidateName + " on the above mentioned date and time.";
                
        //        var formattedHtml = html.Replace("##AssigneeName##", candidateInterviewScheduleUpsertInputModel.Name).
        //            Replace("##InterviewDate##", candidateInterviewScheduleUpsertInputModel.InterviewDate.ToString()).
        //            Replace("##StartTime##", candidateInterviewScheduleUpsertInputModel.StartTime).
        //            Replace("##CandidateName##", candidateInterviewScheduleUpsertInputModel.CandidateName).
        //            Replace("##Description##", description).
        //            Replace("##InterviewRound##", candidateInterviewScheduleUpsertInputModel.InterviewTypeName);
                
        //            EmailGenericModel emailModel = new EmailGenericModel
        //            {
        //                SmtpServer = smtpDetails?.SmtpServer,
        //                SmtpServerPort = smtpDetails?.SmtpServerPort,
        //                SmtpMail = smtpDetails?.SmtpMail,
        //                SmtpPassword = smtpDetails?.SmtpPassword,
        //                ToAddresses = new[] { candidateInterviewScheduleUpsertInputModel.EmailAddress },
        //                HtmlContent = formattedHtml,
        //                Subject = "Snovasys Business Suite: Interview Schedule Remainder",
        //                CCMails = null,
        //                BCCMails = null,
        //                MailAttachments = null,
        //                IsPdf = null
        //            };
        //            _emailService.SendMail(loggedInContext, emailModel);
                
        //    }
        //}

        public void SendScheduleRemainderEmails(CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel, bool isCandidate, string Company, bool? isVideo = false)
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            LoggedInContext loggedInContext = new LoggedInContext();
            string id = candidateInterviewScheduleUpsertInputModel.AssignToUserId.ToString();
            loggedInContext.LoggedInUserId = Guid.Parse(id);
            Guid company = Guid.Parse(Company);
            loggedInContext.CompanyGuid = company;
            if (candidateInterviewScheduleUpsertInputModel.EmailAddress != null)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                var html = _goalRepository.GetHtmlTemplateByName("CandidateScheduleRemainderTemplate", candidateInterviewScheduleUpsertInputModel.CompanyId);
                string description, joinDescription;
                if(isCandidate)
                {
                    description = "You have been scheduled to attend an interview on the above mentioned date and time.";
                    if(candidateInterviewScheduleUpsertInputModel.IsVideoCalling == true && isVideo == false)
                    {
                        description = description + " You will be receiving a mail with link to join the video call before scheduled time.";
                    }
                }
                else
                {
                    description = "You have been assigned to conduct interview for the candidate of " + candidateInterviewScheduleUpsertInputModel.CandidateName + " on the above mentioned date and time.";
                    if (candidateInterviewScheduleUpsertInputModel.IsVideoCalling == true && isVideo == false)
                    {
                        description = description + " You will be receiving a mail with link to join the video call before scheduled time.";
                    }
                }

                if (isVideo == true && candidateInterviewScheduleUpsertInputModel.IsVideoCalling == true)
                {
                    var names = candidateInterviewScheduleUpsertInputModel.CandidateName.Split(' ');
                    var roomName = candidateInterviewScheduleUpsertInputModel.InterviewTypeName + "" + candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId.ToString() + "" + names[0];
                    var address = ConfigurationManager.AppSettings["SiteUrl"];
                    var url = address + "/application/joincall/" + roomName + "/"+ candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId;
                    if (isCandidate)
                    {
                        joinDescription = "Click here to join meeting <a class=" + '"' + "o_text-dark_light o_underline" + '"' + "href=" + '"' + url + '"' + " style=" + "text - decoration: underline; outline: none; color: #dbe5ea;" + ">Join call</a>";
                    }
                    else
                    {
                        joinDescription = "Click here to join meeting <a class=" + '"' + "o_text-dark_light o_underline" + '"' + "href=" + '"' + url + '"' + " style=" + "text - decoration: underline; outline: none; color: #dbe5ea;" + ">Join call</a><br><b>Room name: </b> <p> "+ roomName + "</p>";
                    }
                }
                else
                {
                    joinDescription = "";
                }
               
                var formattedHtml = html.Replace("##AssigneeName##", candidateInterviewScheduleUpsertInputModel.Name).
                    Replace("##InterviewDate##", candidateInterviewScheduleUpsertInputModel.InterviewDate?.ToString("dddd, dd MMMM yyyy")).
                    Replace("##StartTime##", candidateInterviewScheduleUpsertInputModel.StartTime).
                    Replace("##CandidateName##", candidateInterviewScheduleUpsertInputModel.CandidateName).
                    Replace("##Description##", description).
                    Replace("##JoinDescription##", joinDescription).
                    Replace("##InterviewRound##", candidateInterviewScheduleUpsertInputModel.InterviewTypeName);

                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { candidateInterviewScheduleUpsertInputModel.EmailAddress },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: Interview Schedule Remainder",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);

            }
        }

        public List<CandidateInterviewScheduleSearchOutputModel> GetUserCandidateInterviewSchedules(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserCandidateInterviewSchedules", "Recruitment Service"));
            //LoggingManager.Debug(candidateInterviewScheduleSearchInputModel.ToString());
            //_auditService.SaveAudit(AppCommandConstants.GetCandidateInterviewScheduleCommandId, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateInterviewScheduleSearchOutputModel> interviewProcessConfiguration = _recruitmentRepository.GetUserCandidateInterviewSchedules(loggedInContext, validationMessages).ToList();
            return interviewProcessConfiguration;
        }

        public List<CandidateInterviewScheduleSearchOutputModel> GetCandidateInterviewSchedule(CandidateInterviewScheduleSearchInputModel candidateInterviewScheduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateInterviewSchedule", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewScheduleSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidateInterviewScheduleCommandId, candidateInterviewScheduleSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateInterviewScheduleSearchOutputModel> interviewProcessConfiguration = _recruitmentRepository.GetCandidateInterviewSchedule(candidateInterviewScheduleSearchInputModel, loggedInContext, validationMessages).ToList();
            return interviewProcessConfiguration;
        }

        public List<CandidateInterviewScheduleSearchOutputModel> GetCandidateInterviewer(CandidateInterviewScheduleSearchInputModel candidateInterviewScheduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateInterviewSchedule", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewScheduleSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidateInterviewScheduleCommandId, candidateInterviewScheduleSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateInterviewScheduleSearchOutputModel> interviewProcessConfiguration = _recruitmentRepository.GetCandidateInterviewer(candidateInterviewScheduleSearchInputModel, loggedInContext, validationMessages).ToList();
            return interviewProcessConfiguration;
        }

        public Guid? UpsertCandidateInterviewFeedBack(CandidateInterviewFeedBackUpsertInputModel candidateInterviewFeedBackUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateInterviewFeedBack", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewFeedBackUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateInterviewFeedBackCommandId, candidateInterviewFeedBackUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateInterviewFeedBackUpsertInputModel(candidateInterviewFeedBackUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            candidateInterviewFeedBackUpsertInputModel.CandidateInterviewFeedBackId = _recruitmentRepository.UpsertCandidateInterviewFeedBack(candidateInterviewFeedBackUpsertInputModel, loggedInContext, validationMessages);
            return candidateInterviewFeedBackUpsertInputModel.CandidateInterviewFeedBackId;
        }

        public List<CandidateInterviewFeedbackSearchOutputModel> GetCandidateInterviewFeedBack(CandidateInterviewFeedbackSearchInputModel candidateInterviewFeedbackSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateInterviewFeedBack", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewFeedbackSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidateInterviewFeedBackCommandId, candidateInterviewFeedbackSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateInterviewFeedbackSearchOutputModel> CandidateInterviewFeedBack = _recruitmentRepository.GetCandidateInterviewFeedBack(candidateInterviewFeedbackSearchInputModel, loggedInContext, validationMessages).ToList();
            return CandidateInterviewFeedBack;
        }

        public Guid? UpsertCandidateInterviewFeedBackComments(CandidateInterviewFeedBackCommentsUpsertInputModel candidateInterviewFeedBackCommentsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateInterviewFeedBackComments", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewFeedBackCommentsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateInterviewFeedBackCommentCommandId, candidateInterviewFeedBackCommentsUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateInterviewFeedBackCommentsUpsertInputModel(candidateInterviewFeedBackCommentsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            candidateInterviewFeedBackCommentsUpsertInputModel.CandidateInterviewFeedBackCommentsId = _recruitmentRepository.UpsertCandidateInterviewFeedBackComments(candidateInterviewFeedBackCommentsUpsertInputModel, loggedInContext, validationMessages);
            return candidateInterviewFeedBackCommentsUpsertInputModel.CandidateInterviewFeedBackCommentsId;
        }

        public List<CandidateInterviewFeedbackCommentsSearchOutputModel> GetCandidateInterviewFeedBackComments(CandidateInterviewFeedbackCommentsSearchInputModel candidateInterviewFeedbackCommentsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateInterviewFeedBack", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewFeedbackCommentsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetCandidateInterviewFeedBackCommentCommandId, candidateInterviewFeedbackCommentsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateInterviewFeedbackCommentsSearchOutputModel> CandidateInterviewFeedBack = _recruitmentRepository.GetCandidateInterviewFeedBackComments(candidateInterviewFeedbackCommentsSearchInputModel, loggedInContext, validationMessages).ToList();
            return CandidateInterviewFeedBack;
        }
        public void CandidateInterviewScheduleEmail(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var contactMail = candidateInterviewscheduleUpsertInputModel.EmailAddress;

            CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
            {
                Key = "CompanySigninLogo",
                IsArchived = false
            };

            string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);
            var address = ConfigurationManager.AppSettings["SiteUrl"];
            var siteAddress = address + "/recruitment/recruitmentschedules/" + candidateInterviewscheduleUpsertInputModel.CandidateInterviewScheduleId;

            var html = _goalRepository.GetHtmlTemplateByName("CandidateInterviewScheduleCancelledTemplate", loggedInContext.CompanyGuid).Replace("##UserName##", candidateInterviewscheduleUpsertInputModel.AssigneeEmail).Replace("##siteAddress##", siteAddress).Replace("##CompanyLogo##", mainLogo).Replace("##CompanyRegistrationLogo##", mainLogo);
            var toMails = contactMail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Interview schedule",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }

        public CandidateInterviewScheduleSearchOutputModel CancelInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CancelInterviewSchedule", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewScheduleUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertCandidateInterviewScheduleCommandId, candidateInterviewScheduleUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.CandidateInterviewScheduleUpsertInputModel(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            var candidateInterviewSchedule = _recruitmentRepository.CancelInterviewSchedule(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages);
            if(candidateInterviewSchedule != null)
            {
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {
                        if (candidateInterviewSchedule != null && candidateInterviewScheduleUpsertInputModel.CandidateEmail != null)
                        {
                            candidateInterviewScheduleUpsertInputModel.EmailAddress = candidateInterviewScheduleUpsertInputModel.CandidateEmail;
                            candidateInterviewScheduleUpsertInputModel.Name = candidateInterviewScheduleUpsertInputModel.CandidateName;
                            candidateInterviewScheduleUpsertInputModel.StartTime = candidateInterviewSchedule.StartTime;
                            candidateInterviewScheduleUpsertInputModel.EndTime = candidateInterviewSchedule.EndTime;
                            BackgroundJob.Enqueue(() =>
                           CancelCandidateInterviewScheduleEmail(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages)
                                );
                        }
                        if (candidateInterviewSchedule != null)
                        {
                            CandidateInterviewScheduleUpsertInputModel inputModel = new CandidateInterviewScheduleUpsertInputModel();
                            inputModel.CandidateInterviewScheduleId = candidateInterviewSchedule.CandidateInterviewScheduleId;

                            var scheduleAssigneeDetail = GetScheduleAssigneeDetails(inputModel, loggedInContext, validationMessages);

                            scheduleAssigneeDetail.ForEach(x =>
                            {
                                if (x.UserName != null)
                                {
                                    candidateInterviewScheduleUpsertInputModel.EmailAddress = x.UserName;
                                    candidateInterviewScheduleUpsertInputModel.Name = x.AssignToUserName;
                                    candidateInterviewScheduleUpsertInputModel.StartTime = candidateInterviewSchedule.StartTime;
                                    candidateInterviewScheduleUpsertInputModel.EndTime = candidateInterviewSchedule.EndTime;
                                    BackgroundJob.Enqueue(() =>
                                   CancelCandidateInterviewScheduleEmail(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages));
                                }
                            });
                        }
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CancelInterviewSchedule", "UpsertCandidateInterviewSchedule ", exception.Message), exception);

                    }
                });
            }

            //CandidateInterviewScheduleSearchInputModel candidateInterviewScheduleSearchInputModel =
            //    new CandidateInterviewScheduleSearchInputModel
            //    {
            //        CandidateId = candidateInterviewScheduleUpsertInputModel.CandidateId,
            //        InterviewTypeId = candidateInterviewScheduleUpsertInputModel.InterviewTypeId
            //    };

            //List<CandidateInterviewScheduleSearchOutputModel> interviewProcessConfiguration = _recruitmentRepository.GetCandidateInterviewSchedule(candidateInterviewScheduleSearchInputModel, loggedInContext, validationMessages).ToList();

            //UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = new UpsertCronExpressionApiReturnModel();

            //CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
            //cronExpressionInputModel.CronExpression = interviewProcessConfiguration[0].CronExpression;
            //cronExpressionInputModel.CustomWidgetId = candidateInterviewScheduleUpsertInputModel.CandidateId;
            //cronExpressionInputModel.CronExpressionId = interviewProcessConfiguration[0].CronExpressionId;
            //cronExpressionInputModel.CustomWidgetId = candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId;
            //cronExpressionInputModel.TimeStamp = interviewProcessConfiguration[0].CronExpressionTimeStamp;
            //cronExpressionInputModel.ScheduleEndDate = interviewProcessConfiguration[0].ScheduleEndDate;
            //cronExpressionInputModel.IsPaused = true;
            //upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

            //if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
            //{

            //    if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
            //    {
            //        RecurringJob.RemoveIfExists(upsertCronExpressionApiReturnModel.JobId.ToString());
            //    }
            //}
            //var scheduleAssigneeDetails = GetScheduleAssigneeDetails(candidateInterviewScheduleUpsertInputModel, loggedInContext, validationMessages);
            //scheduleAssigneeDetails.ForEach(x =>
            //{
            //    if (x.UserName != null)
            //    {
            //        RecurringJob.RemoveIfExists(x.JobId.ToString());
            //        cronExpressionInputModel.CustomWidgetId = x.AssignToUserId;
            //        cronExpressionInputModel.ScheduleEndDate = x.ScheduleEndDate;
            //        cronExpressionInputModel.TimeStamp = x.CronExpressionTimeStamp;
            //        cronExpressionInputModel.CronExpressionId = x.CronExpressionId;
            //        cronExpressionInputModel.JobId = x.JobId;

            //        upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);
            //    }
            //});
            return candidateInterviewSchedule;
        }

        public void CancelCandidateInterviewScheduleEmail(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var contactMail = candidateInterviewscheduleUpsertInputModel.EmailAddress;

            CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
            {
                Key = "CompanySigninLogo",
                IsArchived = false
            };

            string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

            var html = _goalRepository.GetHtmlTemplateByName("InterviewScheduleCancelledTemplate", loggedInContext.CompanyGuid)
                .Replace("##UserName##", candidateInterviewscheduleUpsertInputModel.Name ?? "Candidate")
                .Replace("##InterviewRound##", candidateInterviewscheduleUpsertInputModel.InterviewTypeName)
                .Replace("##CompanyLogo##", mainLogo)
                .Replace("##CompanyRegistrationLogo##", mainLogo)
                .Replace("##InterviewDate##", candidateInterviewscheduleUpsertInputModel.InterviewDate?.ToString("dddd, dd MMMM yyyy"))
                .Replace("##InterviewTime##", candidateInterviewscheduleUpsertInputModel.StartTime);

            var toMails = contactMail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Interview schedule cancelled - Notification",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }

        public List<CandidateInterviewScheduleSearchOutputModel> GetScheduleAssigneeDetails(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetScheduleAssigneeDetails", "Recruitment Service"));
            LoggingManager.Debug(candidateInterviewscheduleUpsertInputModel.ToString());
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<CandidateInterviewScheduleSearchOutputModel> scheduleAssigneeDetails = _recruitmentRepository.GetScheduleAssigneeDetails(candidateInterviewscheduleUpsertInputModel, loggedInContext, validationMessages).ToList();
            return scheduleAssigneeDetails;
        }

        public void AssigneeInterviewScheduleApprovalEmail(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isRescheduled)
        {
            var contactMail = candidateInterviewscheduleUpsertInputModel.EmailAddress;

            CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
            {
                Key = "CompanySigninLogo",
                IsArchived = false
            };

            string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);
            var address = ConfigurationManager.AppSettings["SiteUrl"];
            var siteAddress = address + "/recruitment/recruitmentschedules/" + candidateInterviewscheduleUpsertInputModel.CandidateInterviewScheduleId;
            var Description = "";
            var buttonName = "";
            var templateName = "";
            if (isRescheduled == false)
            {
                Description = "You have been assigned to conduct interview for the candidate of <b>" + candidateInterviewscheduleUpsertInputModel.CandidateName + "</b> on the above mentioned date and time.Please confirm if you are okay with the scheduled date and time.";
                buttonName = "Confirm";
                templateName = "Confirm Interview Schedule";
            }
            else
            {
                Description = "You have been rescheduled to conduct interview for the candidate of <b>" + candidateInterviewscheduleUpsertInputModel.CandidateName + "</b> on the above mentioned date and time.Please check the scheduled date and time.";
                buttonName = "View";
                templateName = "Rescheduled Interview";
            }
            
            var html = _goalRepository.GetHtmlTemplateByName("InterviewScheduleApprovalTemplate", loggedInContext.CompanyGuid)
                .Replace("##AssigneeName##", candidateInterviewscheduleUpsertInputModel.Name)
                .Replace("##ApprovalUrl##", siteAddress)
                .Replace("##CompanyLogo##", mainLogo)
                .Replace("##CompanyRegistrationLogo##", mainLogo)
                .Replace("##InterviewRound##", candidateInterviewscheduleUpsertInputModel.InterviewTypeName)
                .Replace("##InterviewDate##", candidateInterviewscheduleUpsertInputModel.InterviewDate?.ToString("dddd, dd MMMM yyyy"))
                .Replace("##InterviewTime##", candidateInterviewscheduleUpsertInputModel.StartTime)
                .Replace("##CandidateName##", candidateInterviewscheduleUpsertInputModel.CandidateName)
            .Replace("##Description##", Description)
            .Replace("##ButtonName##", buttonName)
            .Replace("##TemplateName##", templateName);
            var toMails = contactMail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Interview schedule approval - Notification",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }

        public void CandidateInterviewScheduleConfirmedMail(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var contactMail = candidateInterviewscheduleUpsertInputModel.EmailAddress;

            CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
            {
                Key = "CompanySigninLogo",
                IsArchived = false
            };

            string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);
            var address = ConfigurationManager.AppSettings["SiteUrl"];
            var siteAddress = address + "/recruitment/recruitmentschedules/" + candidateInterviewscheduleUpsertInputModel.CandidateInterviewScheduleId;
            string videoCallMessage = "";
            if (candidateInterviewscheduleUpsertInputModel.IsVideoCalling == true)
            {
                videoCallMessage = "You will be receiving a mail with video call joining link before the interview start time.";
            }

            var html = _goalRepository.GetHtmlTemplateByName("InterviewScheduleConfirmedTemplate", loggedInContext.CompanyGuid)
                .Replace("##AssigneeName##", candidateInterviewscheduleUpsertInputModel.Name)
                .Replace("##ApprovalUrl##", siteAddress)
                .Replace("##CompanyLogo##", mainLogo)
                .Replace("##CompanyRegistrationLogo##", mainLogo)
                .Replace("##InterviewRound##", candidateInterviewscheduleUpsertInputModel.InterviewTypeName)
                .Replace("##InterviewDate##", candidateInterviewscheduleUpsertInputModel.InterviewDate?.ToString("dddd, dd MMMM yyyy"))
                .Replace("##InterviewTime##", candidateInterviewscheduleUpsertInputModel.StartTime)
                .Replace("##VideoCallMessage##", videoCallMessage)
                .Replace("##CandidateName##", candidateInterviewscheduleUpsertInputModel.CandidateName);
            var toMails = contactMail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Interview schedule confirmation - Notification",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }
    }
}
