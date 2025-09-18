using System;
using Btrak.Models;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.ComplianceAudit;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using Btrak.Models.TestRail;
using Btrak.Models.Widgets;
using Btrak.Dapper.Dal.Partial;
using Hangfire;
using Btrak.Models.UserStory;
using Btrak.Services.Chromium;
using System.Threading.Tasks;
using System.Globalization;
using Btrak.Models.SystemManagement;
using System.IO;
using System.Web;
using Btrak.Models.MasterData;
using Newtonsoft.Json;
using Btrak.Services.MasterData;
using Btrak.Models.File;
using static BTrak.Common.Enumerators;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage;
using Microsoft.Azure;
using System.Text.RegularExpressions;
using Btrak.Models.CompanyStructure;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml;
using CsvHelper;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.AutomatedWorkflowmanagement;
using Btrak.Models.WorkflowManagement;
using Btrak.Services.Projects;
using Newtonsoft.Json.Serialization;
using Btrak.Models.Audit;
using Btrak.Dapper.Dal.Models;
using Btrak.Models.SoftLabelConfigurations;

namespace Btrak.Services.ComplianceAudit
{
    public class ComplianceAuditService : IComplianceAuditService
    {
        private readonly ComplianceAuditRepository _complianceAuditRepository;
        private readonly IAuditService _auditService;
        private readonly IProjectService _projectService;
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private readonly IChromiumService _chromiumService;
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly MasterDataManagementRepository _masterDataManagementRepository = new MasterDataManagementRepository();
        private readonly CompanyStructureRepository _companyStructureRepository = new CompanyStructureRepository();
        private readonly IMasterDataManagementService _masterDataManagementService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        private readonly IAutomatedWorkflowmanagementServices _automatedWorkflowmanagementServices;
        public ComplianceAuditService(IProjectService projectService, IChromiumService chromiumService, IEmailService emailService, ComplianceAuditRepository complianceAuditRepository, IAuditService auditService, IMasterDataManagementService masterDataManagementService, ICompanyStructureService companyStructureService, IAutomatedWorkflowmanagementServices automatedWorkflowmanagementServices)
        {
            _complianceAuditRepository = complianceAuditRepository;
            _auditService = auditService;
            _chromiumService = chromiumService;
            _masterDataManagementService = masterDataManagementService;
            _companyStructureService = companyStructureService;
            _emailService = emailService;
            _projectService = projectService;
            _automatedWorkflowmanagementServices = automatedWorkflowmanagementServices;
        }

        public Guid? UpsertAuditCompliance(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditCompliance", "ComplianceAudit Service"));

            auditComplianceApiInputModel.AuditName = auditComplianceApiInputModel.AuditName?.Trim();
            auditComplianceApiInputModel.SchedulingDetailsString = JsonConvert.SerializeObject(auditComplianceApiInputModel.SchedulingDetails?.Select(x => new
            {
                CronExpressionId = x.CronExpressionId,
                JobId = x.JobId,
                CronExpression = x.CronExpression,
                ConductStartDate = x.ConductStartDate,
                ConductEndDate = x.ConductEndDate,
                SpanInYears = x.SpanInYears,
                SpanInMonths = x.SpanInMonths,
                SpanInDays = x.SpanInDays,
                IsPaused = x.IsPaused,
                IsArchived = x.IsArchived,
                ResponsibleUserId = x.ResponsibleUserId
            }));

            Guid? auditComplianceId = _complianceAuditRepository.UpsertAuditCompliance(auditComplianceApiInputModel, loggedInContext, validationMessages);
            if (auditComplianceApiInputModel.ToSetDefaultWorkflows == true)
            {
                var model = new DefaultWorkflowModel();
                model.AuditDefaultWorkflowId = auditComplianceApiInputModel.AuditDefaultWorkflowId;
                model.ConductDefaultWorkflowId = auditComplianceApiInputModel.ConductDefaultWorkflowId;
                model.QuestionDefaultWorkflowId = auditComplianceApiInputModel.QuestionDefaultWorkflowId;
                _automatedWorkflowmanagementServices.UpsertDefaultWorkFlow(model, loggedInContext, validationMessages);
            }
            Task.Factory.StartNew(() =>
            {
                AuditComplianceApiReturnModel auditDetails = new AuditComplianceApiReturnModel();

                if (auditComplianceId != null && auditComplianceId != Guid.Empty)
                {
                    //DefaultWorkflowModel defaultWorkflows = _automatedWorkflowmanagementServices.GetDefaultWorkFlows(loggedInContext, validationMessages).FirstOrDefault();
                    AuditComplianceApiInputModel auditComplianceModel = new AuditComplianceApiInputModel();
                    auditComplianceModel.AuditId = auditComplianceId;
                    auditDetails = SearchAudits(auditComplianceModel, loggedInContext, validationMessages).FirstOrDefault();

                    if (auditComplianceApiInputModel.AuditWorkFlowId != null)
                    {
                        _automatedWorkflowmanagementServices.UpsertGenericStatus(new GenericStatusModel()
                        {
                            ReferenceId = auditComplianceId,
                            ReferenceTypeId = AppConstants.AuditsReferenceTypeId,
                            Status = AppConstants.DraftStatus,
                            WorkFlowId = auditComplianceApiInputModel.AuditWorkFlowId
                        }, loggedInContext, validationMessages);
                    }
                    //else if(auditComplianceApiInputModel.EnableWorkFlowForAudit == true && defaultWorkflows != null && defaultWorkflows.AuditDefaultWorkflowId != null && defaultWorkflows.AuditDefaultWorkflowId != Guid.Empty)
                    //{
                    //    _automatedWorkflowmanagementServices.UpsertGenericStatus(new GenericStatusModel()
                    //    {
                    //        ReferenceId = auditComplianceId,
                    //        ReferenceTypeId = AppConstants.AuditsReferenceTypeId,
                    //        Status = AppConstants.DraftStatus,
                    //        WorkFlowId = auditComplianceApiInputModel.AuditWorkFlowId
                    //    }, loggedInContext, validationMessages);
                    //}

                    if (auditComplianceApiInputModel.ConductWorkFlowId != null)
                    {
                        _automatedWorkflowmanagementServices.UpsertGenericStatus(new GenericStatusModel()
                        {
                            ReferenceId = auditComplianceId,
                            ReferenceTypeId = AppConstants.ConductsReferenceTypeId,
                            Status = AppConstants.DraftStatus,
                            WorkFlowId = auditComplianceApiInputModel.ConductWorkFlowId
                        }, loggedInContext, validationMessages);
                    }
                    //else if (auditComplianceApiInputModel.EnableWorkFlowForAuditConduct == true && defaultWorkflows != null && defaultWorkflows.ConductDefaultWorkflowId != null && defaultWorkflows.ConductDefaultWorkflowId != Guid.Empty)
                    //{
                    //    _automatedWorkflowmanagementServices.UpsertGenericStatus(new GenericStatusModel()
                    //    {
                    //        ReferenceId = auditComplianceId,
                    //        ReferenceTypeId = AppConstants.ConductsReferenceTypeId,
                    //        Status = AppConstants.DraftStatus,
                    //        WorkFlowId = auditComplianceApiInputModel.ConductWorkFlowId
                    //    }, loggedInContext, validationMessages);
                    //}

                    if (auditComplianceApiInputModel.EnableQuestionLevelWorkFlow != true)
                    {
                        _complianceAuditRepository.ArchiveGenericStatusOfAuditQuestions(auditComplianceId, loggedInContext, validationMessages);
                    }
                }

            });

            if (auditComplianceId != null && auditComplianceId != Guid.Empty && auditComplianceApiInputModel.SchedulingDetails != null && auditComplianceApiInputModel.SchedulingDetails.Length > 0 && auditComplianceApiInputModel.RecurringAudit == true)
            {
                foreach (var schedulingData in auditComplianceApiInputModel.SchedulingDetails)
                {
                    CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
                    cronExpressionInputModel.CronExpressionId = schedulingData.CronExpressionId;
                    cronExpressionInputModel.CronExpression = schedulingData.CronExpression;
                    cronExpressionInputModel.CronExpressionDescription = schedulingData.CronExpressionDescription;
                    cronExpressionInputModel.CustomWidgetId = auditComplianceId;
                    cronExpressionInputModel.TimeStamp = schedulingData.CronExpressionTimeStamp;
                    cronExpressionInputModel.ScheduleEndDate = schedulingData.ScheduleEndDate;
                    cronExpressionInputModel.IsPaused = schedulingData.IsPaused;
                    cronExpressionInputModel.ConductStartDate = schedulingData.ConductStartDate;
                    cronExpressionInputModel.ConductEndDate = schedulingData.ConductEndDate;
                    cronExpressionInputModel.CreatedDateTime = DateTime.UtcNow;
                    cronExpressionInputModel.IsArchived = schedulingData.IsArchived;
                    cronExpressionInputModel.ResponsibleUserId = schedulingData.ResponsibleUserId;

                    UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

                    if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
                    {
                        var schedulerObject = auditComplianceApiInputModel.SchedulingDetails.Where(x => x.CronExpression == cronExpressionInputModel.CronExpression).FirstOrDefault();

                        cronExpressionInputModel.SpanInDays = schedulerObject.SpanInDays;
                        cronExpressionInputModel.SpanInMonths = schedulerObject.SpanInMonths;
                        cronExpressionInputModel.SpanInYears = schedulerObject.SpanInYears;

                        string scheduleString = JsonConvert.SerializeObject(new
                        {
                            schedulerObject.CronExpressionId,
                            schedulerObject.JobId,
                            schedulerObject.CronExpression,
                            schedulerObject.ConductStartDate,
                            schedulerObject.ConductEndDate,
                            schedulerObject.SpanInYears,
                            schedulerObject.SpanInMonths,
                            schedulerObject.SpanInDays,
                            schedulerObject.IsPaused,
                            schedulerObject.IsArchived,
                            schedulerObject.ResponsibleUserId
                        });

                        string selectedQuestions = JsonConvert.SerializeObject(schedulerObject.SelectedQuestions);

                        Guid? scheduleId = _complianceAuditRepository.UpsertAuditComplianceSchedulingDetails(
                            auditComplianceId.Value, upsertCronExpressionApiReturnModel.CronExpressionId.Value, scheduleString, selectedQuestions, schedulerObject.IsIncludeAllQuestions, loggedInContext, validationMessages);

                        if ((cronExpressionInputModel.IsPaused == null || cronExpressionInputModel.IsPaused == false) && cronExpressionInputModel.IsArchived != true)
                        {
                            bool isToIncludeAllQuestions = schedulerObject.IsIncludeAllQuestions;
                            List<SelectedQuestionModel> auditQuestionsList = new List<SelectedQuestionModel>();
                            string SelectedQuestionsXml = null;

                            auditQuestionsList = GetQuestionsBasedonAuditId(auditComplianceId, loggedInContext, validationMessages);

                            auditComplianceApiInputModel.AuditId = auditComplianceId;
                            cronExpressionInputModel.CronExpression = cronExpressionInputModel.CronExpression.Replace('?', '*');

                            var timeZone = TimeZoneInfo.Utc;
                            if (!string.IsNullOrEmpty(loggedInContext.TimeZoneString))
                            {
                                timeZone = TimeZoneInfo.FindSystemTimeZoneById(loggedInContext.TimeZoneString);
                            }

                            RecurringJob.AddOrUpdate(upsertCronExpressionApiReturnModel.JobId.ToString(),
                            () => PostMethod(auditComplianceApiInputModel, cronExpressionInputModel, loggedInContext, validationMessages, isToIncludeAllQuestions, auditQuestionsList),
                                cronExpressionInputModel.CronExpression, timeZone);
                        }
                        else if (cronExpressionInputModel.IsPaused == true || cronExpressionInputModel.IsArchived == true)
                        {
                            if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
                            {
                                RecurringJob.RemoveIfExists(upsertCronExpressionApiReturnModel.JobId.ToString());
                            }
                        }
                    }
                }

            }
            else if (auditComplianceId != null && auditComplianceId != Guid.Empty && auditComplianceApiInputModel.SchedulingDetails != null
                && auditComplianceApiInputModel.RecurringAudit == false && auditComplianceApiInputModel.SchedulingDetails.Length > 0)
            {

                foreach (var schedulerData in auditComplianceApiInputModel.SchedulingDetails)
                {
                    CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
                    cronExpressionInputModel.CronExpressionId = schedulerData.CronExpressionId;
                    cronExpressionInputModel.CronExpression = schedulerData.CronExpression;
                    cronExpressionInputModel.CronExpressionDescription = schedulerData.CronExpressionDescription;
                    cronExpressionInputModel.CustomWidgetId = auditComplianceId;
                    cronExpressionInputModel.TimeStamp = schedulerData.CronExpressionTimeStamp;
                    cronExpressionInputModel.IsArchived = true;

                    UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

                    if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
                    {
                        RecurringJob.RemoveIfExists(upsertCronExpressionApiReturnModel.JobId.ToString());
                    }
                }
            }
            else if (auditComplianceApiInputModel.SchedulingDetails != null && auditComplianceApiInputModel.SchedulingDetails.Length > 0
                && auditComplianceApiInputModel.IsArchived == true)
            {
                foreach (var schedulerData in auditComplianceApiInputModel.SchedulingDetails)
                {
                    CronExpressionInputModel cronExpressionInputModel = new CronExpressionInputModel();
                    cronExpressionInputModel.CronExpressionId = schedulerData.CronExpressionId;
                    cronExpressionInputModel.CronExpression = schedulerData.CronExpression;
                    cronExpressionInputModel.CronExpressionDescription = schedulerData.CronExpressionDescription;
                    cronExpressionInputModel.CustomWidgetId = auditComplianceId;
                    cronExpressionInputModel.TimeStamp = schedulerData.CronExpressionTimeStamp;
                    cronExpressionInputModel.IsArchived = true;

                    UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

                    if (upsertCronExpressionApiReturnModel != null && upsertCronExpressionApiReturnModel.JobId != null)
                    {
                        RecurringJob.RemoveIfExists(upsertCronExpressionApiReturnModel.JobId.ToString());
                    }
                }
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertAuditCompliance, auditComplianceApiInputModel, loggedInContext);

            LoggingManager.Debug(auditComplianceApiInputModel.AuditId?.ToString());

            return auditComplianceId;
        }

        public void SubmitAuditCompliance(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (auditComplianceApiInputModel.AuditWorkFlowId != null && auditComplianceApiInputModel.AuditWorkFlowId != Guid.Empty)
            {
                _automatedWorkflowmanagementServices.UpsertGenericStatus(new GenericStatusModel()
                {
                    ReferenceId = auditComplianceApiInputModel.AuditId,
                    ReferenceTypeId = AppConstants.AuditsReferenceTypeId,
                    WorkFlowId = auditComplianceApiInputModel.AuditWorkFlowId,
                    Status = AppConstants.SubmittedStatus,
                }, loggedInContext, validationMessages);
            }
            else
            {
                DefaultWorkflowModel defaultWorkflows = _automatedWorkflowmanagementServices.GetDefaultWorkFlows(loggedInContext, validationMessages).FirstOrDefault();
                if (defaultWorkflows != null && defaultWorkflows.AuditDefaultWorkflowId != null && defaultWorkflows.AuditDefaultWorkflowId != Guid.Empty)
                {
                    _automatedWorkflowmanagementServices.UpsertGenericStatus(new GenericStatusModel()
                    {
                        ReferenceId = auditComplianceApiInputModel.AuditId,
                        ReferenceTypeId = AppConstants.AuditsReferenceTypeId,
                        Status = AppConstants.SubmittedStatus,
                        WorkFlowId = defaultWorkflows.AuditDefaultWorkflowId
                    }, loggedInContext, validationMessages);

                }
            }

            GenericStatusModel genericStatusModel = _automatedWorkflowmanagementServices.GetGenericStatus(new GenericStatusModel()
            {
                ReferenceId = auditComplianceApiInputModel.AuditId,
                ReferenceTypeId = AppConstants.AuditsReferenceTypeId
            }, loggedInContext, validationMessages).FirstOrDefault();

            CheckAndStartWorkflowIfAny(genericStatusModel, loggedInContext, validationMessages);

        }

        public void CheckAndStartWorkflowIfAny(GenericStatusModel genericStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            if (genericStatusModel != null)
            {
                if (genericStatusModel.WorkFlowId != null)
                {
                    try
                    {
                        WorkFlowTriggerModel workflow = _automatedWorkflowmanagementServices.GetWorkflowBasedOnWorkflowId(genericStatusModel.WorkFlowId, loggedInContext, validationMessages);

                        workflow.ReferenceId = genericStatusModel.ReferenceId;
                        workflow.ReferenceTypeId = genericStatusModel.ReferenceTypeId;
                        workflow.Answer = genericStatusModel.Answer;

                        if (!string.IsNullOrEmpty(workflow.WorkflowXml))
                        {
                            _automatedWorkflowmanagementServices.StartWorkflowProcessInstance(workflow, loggedInContext, validationMessages);
                        }
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckAndStartWorkflowIfAny", "ComplianceAuditService ", exception.Message), exception);

                    }

                }
            }
        }

        public Guid? UpsertAuditFolder(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditFolder", "ComplianceAudit Service"));

            LoggingManager.Debug(auditComplianceApiInputModel.ToString());

            Guid? auditComplianceId = _complianceAuditRepository.UpsertAuditFolder(auditComplianceApiInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertAuditCompliance, auditComplianceApiInputModel, loggedInContext);

            LoggingManager.Debug(auditComplianceApiInputModel.AuditId?.ToString());

            return auditComplianceId;
        }

        public Guid? CloneAudit(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditCompliance", "ComplianceAudit Service"));

            LoggingManager.Debug(auditComplianceApiInputModel.ToString());

            Guid? auditComplianceId = null;

            if (auditComplianceApiInputModel != null && auditComplianceApiInputModel.AuditVersionId != null)
            {
                auditComplianceId = _complianceAuditRepository.CloneAuditByVersionId(auditComplianceApiInputModel, loggedInContext, validationMessages);
            }
            else
            {
                auditComplianceId = _complianceAuditRepository.CloneAudit(auditComplianceApiInputModel, loggedInContext, validationMessages);
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertAuditCompliance, auditComplianceApiInputModel, loggedInContext);

            LoggingManager.Debug(auditComplianceApiInputModel.AuditId?.ToString());

            return auditComplianceId;
        }

        public Guid? SubmitAuditConductQuestion(SubmitAuditConductApiInputModel submitAuditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditCompliance", "ComplianceAudit Service"));

            submitAuditConductApiInputModel.AnswerComment = submitAuditConductApiInputModel.AnswerComment?.Trim();

            LoggingManager.Debug(submitAuditConductApiInputModel.ToString());

            Guid? submittedId = _complianceAuditRepository.SubmitAuditConductQuestion(submitAuditConductApiInputModel, loggedInContext, validationMessages);

            Task.Factory.StartNew(() =>
            {
                GenericStatusModel genericQuestionStatusModel = _automatedWorkflowmanagementServices.GetGenericStatus(new GenericStatusModel()
                {
                    ReferenceId = submitAuditConductApiInputModel.QuestionId,
                    ReferenceTypeId = AppConstants.AuditQuestionsReferenceTypeId
                }, loggedInContext, validationMessages).FirstOrDefault();
                if (genericQuestionStatusModel != null && (genericQuestionStatusModel.WorkFlowId != null || genericQuestionStatusModel.WorkFlowId != Guid.Empty))
                {
                    GenericStatusModel genericStatusModel = new GenericStatusModel()
                    {
                        ReferenceId = submitAuditConductApiInputModel.AuditConductQuestionId,
                        ReferenceTypeId = AppConstants.AuditQuestionsReferenceTypeId,
                        Status = AppConstants.DraftStatus,
                        WorkFlowId = genericQuestionStatusModel.WorkFlowId
                    };

                    var genericStatusId = _automatedWorkflowmanagementServices.UpsertGenericStatus(genericStatusModel, loggedInContext, validationMessages);
                    genericStatusModel.GenericStatusId = genericStatusId;
                    AuditQuestionsApiInputModel model = new AuditQuestionsApiInputModel();
                    model.ConductId = submitAuditConductApiInputModel.ConductId;
                    model.QuestionId = submitAuditConductApiInputModel.QuestionId;
                    var conductQuestion = SearchAuditConductQuestions(model, loggedInContext, validationMessages).FirstOrDefault();
                    if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.TextQuestionTypeId.ToLower())
                    {
                        genericStatusModel.Answer = conductQuestion.QuestionResultText;
                    }
                    else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.BooleanQuestionTypeId.ToLower() || conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.DropdownQuestionTypeId.ToLower())
                    {
                        genericStatusModel.Answer = conductQuestion.QuestionResult;
                    }
                    else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.DateQuestionTypeId.ToLower())
                    {
                        genericStatusModel.Answer = conductQuestion.QuestionResultDate;
                    }
                    else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.NumericQuestionTypeId.ToLower())
                    {
                        genericStatusModel.Answer = conductQuestion.QuestionResultNumeric;
                    }
                    else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.TimeQuestionTypeId.ToLower())
                    {
                        genericStatusModel.Answer = conductQuestion.QuestionResultTime;
                    }

                    CheckAndStartWorkflowIfAny(genericStatusModel, loggedInContext, validationMessages);
                }
                else if (submitAuditConductApiInputModel.EnableQuestionLevelWorkFlow == true && submitAuditConductApiInputModel.QuestionWorkflowId != null
                  && submitAuditConductApiInputModel.QuestionWorkflowId != Guid.Empty)
                {
                    GenericStatusModel genericQuestionStatusModell = _automatedWorkflowmanagementServices.GetGenericStatus(new GenericStatusModel()
                    {
                        ReferenceId = submitAuditConductApiInputModel.AuditConductQuestionId,
                        ReferenceTypeId = AppConstants.AuditQuestionsReferenceTypeId
                    }, loggedInContext, validationMessages).FirstOrDefault();
                    if (genericQuestionStatusModell != null && (genericQuestionStatusModell.WorkFlowId != null || genericQuestionStatusModell.WorkFlowId != Guid.Empty))
                    {
                        GenericStatusModel genericStatusModel = new GenericStatusModel()
                        {
                            ReferenceId = submitAuditConductApiInputModel.AuditConductQuestionId,
                            ReferenceTypeId = AppConstants.AuditQuestionsReferenceTypeId,
                            Status = AppConstants.DraftStatus,
                            WorkFlowId = genericQuestionStatusModell.WorkFlowId
                        };

                        var genericStatusId = _automatedWorkflowmanagementServices.UpsertGenericStatus(genericStatusModel, loggedInContext, validationMessages);
                        genericStatusModel.GenericStatusId = genericStatusId;
                        AuditQuestionsApiInputModel model = new AuditQuestionsApiInputModel();
                        model.ConductId = submitAuditConductApiInputModel.ConductId;
                        model.QuestionId = submitAuditConductApiInputModel.QuestionId;
                        var conductQuestion = SearchAuditConductQuestions(model, loggedInContext, validationMessages).FirstOrDefault();
                        if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.TextQuestionTypeId.ToLower())
                        {
                            genericStatusModel.Answer = conductQuestion.QuestionResultText;
                        }
                        else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.BooleanQuestionTypeId.ToLower() || conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.DropdownQuestionTypeId.ToLower())
                        {
                            genericStatusModel.Answer = conductQuestion.QuestionResult;
                        }
                        else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.DateQuestionTypeId.ToLower())
                        {
                            genericStatusModel.Answer = conductQuestion.QuestionResultDate;
                        }
                        else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.NumericQuestionTypeId.ToLower())
                        {
                            genericStatusModel.Answer = conductQuestion.QuestionResultNumeric;
                        }
                        else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.TimeQuestionTypeId.ToLower())
                        {
                            genericStatusModel.Answer = conductQuestion.QuestionResultTime;
                        }

                        CheckAndStartWorkflowIfAny(genericStatusModel, loggedInContext, validationMessages);
                    }
                }

            });

            _auditService.SaveAudit(AppCommandConstants.UpsertAuditCompliance, submitAuditConductApiInputModel, loggedInContext);

            return submittedId;
        }

        public List<AuditComplianceApiReturnModel> SearchAuditFolders(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditFolders", "ComplianceAudit Service"));

            LoggingManager.Debug(auditComplianceApiInputModel.ToString());

            List<AuditComplianceApiReturnModel> auditFolders = _complianceAuditRepository.SearchAuditFolders(auditComplianceApiInputModel, loggedInContext, validationMessages).ToList();

            _auditService.SaveAudit(AppCommandConstants.UpsertAuditCompliance, auditComplianceApiInputModel, loggedInContext);

            return auditFolders;
        }

        public List<AuditComplianceApiReturnModel> SearchAudits(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAudits", "AuditCategories Service"));

            LoggingManager.Debug(auditComplianceApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchAduits, auditComplianceApiInputModel, loggedInContext);

            if (auditComplianceApiInputModel != null)
            {
                auditComplianceApiInputModel.MultipleAuditIdsXml =
                    auditComplianceApiInputModel.MultipleAuditIds != null &&
                    auditComplianceApiInputModel.MultipleAuditIds.Count > 0
                        ? Utilities.GetXmlFromObject(auditComplianceApiInputModel.MultipleAuditIds)
                        : null;

                List<AuditComplianceApiReturnModel> auditComplianceApiReturnModels = new List<AuditComplianceApiReturnModel>();

                if (auditComplianceApiInputModel != null && auditComplianceApiInputModel.AuditVersionId != null)
                {
                    auditComplianceApiReturnModels = _complianceAuditRepository
                  .SearchAuditsByAuditVersionId(auditComplianceApiInputModel, loggedInContext, validationMessages).ToList();
                }
                else
                {
                    auditComplianceApiReturnModels = _complianceAuditRepository
                   .SearchAudits(auditComplianceApiInputModel, loggedInContext, validationMessages).ToList();
                }

                if (auditComplianceApiReturnModels != null && auditComplianceApiReturnModels.Count() > 0)
                {
                    auditComplianceApiReturnModels.ForEach((audit) =>
                    {
                        if (audit.AuditTagsModelXml != null)
                        {
                            audit.AuditTagsModels = Utilities.GetObjectFromXml<AuditTagsModel>(audit.AuditTagsModelXml, "AuditTagsModel");
                        }
                        else
                        {
                            audit.AuditTagsModels = new List<AuditTagsModel>();
                        }

                        if (!String.IsNullOrEmpty(audit.SchedulingDetailsString))
                        {
                            audit.SchedulingDetails = JsonConvert.DeserializeObject<List<AuditComplianceSchedulingModel>>(audit.SchedulingDetailsString);
                        }
                    }
                   );
                }
                return auditComplianceApiReturnModels;
            }

            return null;
        }

        public string GetAuditsFolderView(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditsFolderView", "AuditCategories Service"));

            LoggingManager.Debug(auditComplianceApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchAduits, auditComplianceApiInputModel, loggedInContext);

            if (auditComplianceApiInputModel != null)
            {
                auditComplianceApiInputModel.MultipleAuditIdsXml =
                    auditComplianceApiInputModel.MultipleAuditIds != null &&
                    auditComplianceApiInputModel.MultipleAuditIds.Count > 0
                        ? Utilities.GetXmlFromObject(auditComplianceApiInputModel.MultipleAuditIds)
                        : null;

                List<AuditComplianceApiReturnModel> auditComplianceApiReturnModels = new List<AuditComplianceApiReturnModel>();

                if (auditComplianceApiInputModel != null && auditComplianceApiInputModel.BusinessUnitIds != null && auditComplianceApiInputModel.BusinessUnitIds.Count > 0)
                {
                    auditComplianceApiInputModel.BusinessUnitIdsList = string.Join(",", auditComplianceApiInputModel.BusinessUnitIds);
                }

                if (auditComplianceApiInputModel.IsArchived == false || auditComplianceApiInputModel.IsArchived == null)
                {
                    auditComplianceApiReturnModels = _complianceAuditRepository
                        .GetAuditsFolderView(auditComplianceApiInputModel, loggedInContext, validationMessages).ToList();
                }

                if (auditComplianceApiInputModel.IsArchived == true)
                {
                    auditComplianceApiReturnModels = _complianceAuditRepository
                        .GetArchivedAuditsFolderView(auditComplianceApiInputModel, loggedInContext, validationMessages).ToList();
                }

                if (validationMessages.Any())
                {
                    return null;
                }

                if (auditComplianceApiReturnModels != null && auditComplianceApiReturnModels.Count() > 0)
                {
                    auditComplianceApiReturnModels.ForEach((audit) =>
                    {
                        if (audit.AuditTagsModelXml != null)
                        {
                            audit.AuditTagsModels = Utilities.GetObjectFromXml<AuditTagsModel>(audit.AuditTagsModelXml, "AuditTagsModel");
                        }
                        else
                        {
                            audit.AuditTagsModels = new List<AuditTagsModel>();
                        }

                        if (!String.IsNullOrEmpty(audit.SchedulingDetailsString))
                        {
                            audit.SchedulingDetails = JsonConvert.DeserializeObject<List<AuditComplianceSchedulingModel>>(audit.SchedulingDetailsString);
                        }
                    }
                   );
                }

                if (auditComplianceApiReturnModels.Count() > 1)
                {
                    auditComplianceApiReturnModels = GenerateAuditFolderHierarchy(auditComplianceApiReturnModels, auditComplianceApiInputModel?.ParentAuditId, 0);
                }

                var folderJson = "";

                JsonSerializerSettings settings = new JsonSerializerSettings
                {
                    ContractResolver = new CamelCasePropertyNamesContractResolver(),
                    Formatting = Formatting.Indented,
                    NullValueHandling = NullValueHandling.Ignore
                };

                folderJson = JsonConvert.SerializeObject(auditComplianceApiReturnModels, settings);

                return folderJson;
            }

            return null;
        }

        public List<AuditComplianceApiReturnModel> GenerateAuditFolderHierarchy(List<AuditComplianceApiReturnModel> audits, Guid? parentAuditId, int auditLevel)
        {
            return audits.Where(x => x.ParentAuditId.Equals(parentAuditId)).Select(subAudits => new AuditComplianceApiReturnModel
            {
                AuditId = subAudits.AuditId,
                ParentAuditId = subAudits.ParentAuditId,
                AuditName = subAudits.AuditName,
                AuditDescription = subAudits.AuditDescription,
                IsArchived = subAudits.IsArchived,
                IsRAG = subAudits.IsRAG,
                IsAudit = subAudits.IsAudit,
                CanLogTime = subAudits.CanLogTime,
                InBoundPercent = subAudits.InBoundPercent,
                OutBoundPercent = subAudits.OutBoundPercent,
                TotalEstimatedTime = subAudits.TotalEstimatedTime,
                TotalSpentTime = subAudits.TotalSpentTime,
                CreatedDateTime = subAudits.CreatedDateTime,
                UpdatedDateTime = subAudits.UpdatedDateTime,
                InActiveDateTime = subAudits.InActiveDateTime,
                TotalCount = subAudits.TotalCount,
                ConductsCount = subAudits.ConductsCount,
                AuditCategoriesCount = subAudits.AuditCategoriesCount,
                AuditQuestionsCount = subAudits.AuditQuestionsCount,
                ScheduleEndDate = subAudits.ScheduleEndDate,
                ConductStartDate = subAudits.ConductStartDate,
                ConductEndDate = subAudits.ConductEndDate,
                AuditTagsModels = subAudits.AuditTagsModels,
                SchedulingDetails = subAudits.SchedulingDetails,
                EnableQuestionLevelWorkFlow = subAudits.EnableQuestionLevelWorkFlow,
                Auditlevel = auditLevel,
                AuditWorkFlowId = subAudits.AuditWorkFlowId,
                CreatedByUserId = subAudits.CreatedByUserId,
                CreatedByUserName = subAudits.CreatedByUserName,
                CreatedByProfileImage = subAudits.CreatedByProfileImage,
                ResponsibleUserName = subAudits.ResponsibleUserName,
                ResponsibleProfileImage = subAudits.ResponsibleProfileImage,
                ResponsibleUserId = subAudits.ResponsibleUserId,
                TimeStamp = subAudits.TimeStamp,
                FolderTimeStamp = subAudits.FolderTimeStamp,
                ProjectId = subAudits.ProjectId,
                HaveAuditVersions = subAudits.HaveAuditVersions,
                EnableWorkFlowForAudit = subAudits.EnableWorkFlowForAudit,
                EnableWorkFlowForAuditConduct = subAudits.EnableWorkFlowForAuditConduct,
                Status = subAudits.Status,
                StatusColor = subAudits.StatusColor,
                AuditDefaultWorkflowId = subAudits.AuditDefaultWorkflowId,
                ConductDefaultWorkflowId = subAudits.ConductDefaultWorkflowId,
                QuestionDefaultWorkflowId = subAudits.QuestionDefaultWorkflowId,
                HaveCustomFields = subAudits.HaveCustomFields,
                Children = GenerateAuditFolderHierarchy(audits, subAudits.AuditId, auditLevel + 1)
            }).ToList();
        }

        public Guid? UpsertAuditCategory(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditCompliance", "ComplianceAudit Service"));

            auditCategoryApiInputModel.AuditCategoryName = auditCategoryApiInputModel.AuditCategoryName?.Trim();

            LoggingManager.Debug(auditCategoryApiInputModel.ToString());

            Guid? auditCategoryId = _complianceAuditRepository.UpsertAuditCategory(auditCategoryApiInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertAuditCompliance, auditCategoryApiInputModel, loggedInContext);

            LoggingManager.Debug(auditCategoryId?.ToString());

            return auditCategoryId;
        }

        public List<AuditCategoryApiReturnModel> SearchAuditCategories(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAudits", "AuditCategories Service"));

            LoggingManager.Debug(auditCategoryApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchAduits, auditCategoryApiInputModel, loggedInContext);

            List<AuditCategoryApiReturnModel> auditCategoryApiReturnModels = new List<AuditCategoryApiReturnModel>();

            if (auditCategoryApiInputModel != null && auditCategoryApiInputModel.AuditVersionId != null)
            {
                auditCategoryApiReturnModels = _complianceAuditRepository.SearchAuditCategoriesByVersionId(auditCategoryApiInputModel, loggedInContext, validationMessages).ToList();
            }
            else if (auditCategoryApiInputModel != null && auditCategoryApiInputModel.ConductId == null)
            {
                auditCategoryApiReturnModels = _complianceAuditRepository.SearchAuditCategories(auditCategoryApiInputModel, loggedInContext, validationMessages).ToList();
            }
            else
            {
                auditCategoryApiReturnModels = _complianceAuditRepository.SearchConductCategories(auditCategoryApiInputModel, loggedInContext, validationMessages).ToList();

            }
            if (validationMessages.Any())
            {
                return null;
            }

            if (auditCategoryApiReturnModels.Count() > 1)
            {
                auditCategoryApiReturnModels = GenerateCategoryHierarchy(auditCategoryApiReturnModels, auditCategoryApiInputModel?.ParentAuditCategoryId, 0, new List<AuditQuestionsApiReturnModel>());
            }

            return auditCategoryApiReturnModels;
        }

        public ConductAuditCategoryModel SearchAuditCategoriesForConducts(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditCategoriesForConducts", "AuditCategories Service"));

            LoggingManager.Debug(auditCategoryApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchAduits, auditCategoryApiInputModel, loggedInContext);

            ConductAuditCategoryModel conductAuditCategoryModel = new ConductAuditCategoryModel();

            var auditCategoryApiReturnModels = SearchAuditCategories(auditCategoryApiInputModel, loggedInContext, validationMessages).ToList();

            if (validationMessages.Count > 0)
            {
                return null;
            }

            conductAuditCategoryModel.AuditCategories = auditCategoryApiReturnModels;

            var selectedCategories = _complianceAuditRepository.GetConductSelectedCategories(auditCategoryApiInputModel.ConductId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (selectedCategories != null && selectedCategories.Count > 0)
            {
                conductAuditCategoryModel.ConductSelectedCategories = selectedCategories;
            }

            var selectedQuestions = _complianceAuditRepository.GetConductSelectedQuestions(auditCategoryApiInputModel.ConductId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (selectedQuestions != null && selectedQuestions.Count > 0)
            {
                conductAuditCategoryModel.ConductSelectedQuestions = selectedQuestions;
            }

            return conductAuditCategoryModel;
        }

        public List<DropdownModel> GetCategoriesAndSubcategories(Guid? auditId, Guid? auditVersionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCategoriesAndSubcategories", "AuditId", auditId, "Audit Service"));

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetSectionsAndSubSectionsCommandId, auditId, loggedInContext);

            List<DropdownModel> categoriesAndSubcategoriesList = new List<DropdownModel>();

            if (auditVersionId != null)
            {
                categoriesAndSubcategoriesList = _complianceAuditRepository.GetCategoriesAndSubcategoriesByVersionId(auditId, auditVersionId, loggedInContext, validationMessages);
            }
            else
            {
                categoriesAndSubcategoriesList = _complianceAuditRepository.GetCategoriesAndSubcategories(auditId, loggedInContext, validationMessages);
            }

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return categoriesAndSubcategoriesList;
        }

        public List<AuditConductApiReturnModel> SearchAuditConducts(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditConducts", "AuditCategories Service"));

            LoggingManager.Debug(auditConductApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchAduits, auditConductApiInputModel, loggedInContext);

            auditConductApiInputModel = dateConversions(auditConductApiInputModel);

            List<AuditConductApiReturnModel> auditConductApiReturns = _complianceAuditRepository.SearchAuditConducts(auditConductApiInputModel, loggedInContext, validationMessages).ToList();

            if (auditConductApiReturns != null && auditConductApiReturns.Count() > 0)
            {
                auditConductApiReturns.ForEach((audit) =>
                {
                    if (audit.AuditTagsModelXml != null)
                    {
                        audit.AuditTagsModels = Utilities.GetObjectFromXml<AuditTagsModel>(audit.AuditTagsModelXml, "AuditTagsModel");
                    }
                    else
                    {
                        audit.AuditTagsModels = new List<AuditTagsModel>();
                    }

                    if (audit.ConductTagsModelXml != null)
                    {
                        audit.ConductTagsModels = Utilities.GetObjectFromXml<AuditTagsModel>(audit.ConductTagsModelXml, "AuditTagsModel");
                    }
                    else
                    {
                        audit.ConductTagsModels = new List<AuditTagsModel>();
                    }
                }
               );
            }

            if (validationMessages.Count() > 0)
            {
                return null;
            }

            return auditConductApiReturns;
        }

        public string GetConductsFolderView(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConductsFolderView", "AuditCategories Service"));

            LoggingManager.Debug(auditConductApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchAduits, auditConductApiInputModel, loggedInContext);

            auditConductApiInputModel = dateConversions(auditConductApiInputModel);

            List<AuditConductApiReturnModel> auditConductApiReturns = new List<AuditConductApiReturnModel>();

            if (auditConductApiInputModel != null && auditConductApiInputModel.BusinessUnitIds != null && auditConductApiInputModel.BusinessUnitIds.Count > 0)
            {
                auditConductApiInputModel.BusinessUnitIdsList = string.Join(",", auditConductApiInputModel.BusinessUnitIds);
            }

            if (auditConductApiInputModel.IsArchived == false)
            {
                auditConductApiReturns = _complianceAuditRepository.GetConductsFolderView(auditConductApiInputModel, loggedInContext, validationMessages).ToList();
            }

            if (auditConductApiInputModel.IsArchived == true)
            {
                auditConductApiReturns = _complianceAuditRepository.GetArchivedConductsFolderView(auditConductApiInputModel, loggedInContext, validationMessages).ToList();
            }

            if (auditConductApiReturns != null && auditConductApiReturns.Count() > 0)
            {
                auditConductApiReturns.ForEach((audit) =>
                {
                    if (audit.AuditTagsModelXml != null)
                    {
                        audit.AuditTagsModels = Utilities.GetObjectFromXml<AuditTagsModel>(audit.AuditTagsModelXml, "AuditTagsModel");
                    }
                    else
                    {
                        audit.AuditTagsModels = new List<AuditTagsModel>();
                    }

                    if (audit.ConductTagsModelXml != null)
                    {
                        audit.ConductTagsModels = Utilities.GetObjectFromXml<AuditTagsModel>(audit.ConductTagsModelXml, "AuditTagsModel");
                    }
                    else
                    {
                        audit.ConductTagsModels = new List<AuditTagsModel>();
                    }

                }
               );
            }

            if (validationMessages.Count() > 0)
            {
                return null;
            }

            if (auditConductApiReturns.Count() > 1)
            {
                auditConductApiReturns = GenerateConductFolderHierarchy(auditConductApiReturns, auditConductApiInputModel?.ParentConductId, 0);
            }

            var folderJson = "";

            JsonSerializerSettings settings = new JsonSerializerSettings
            {
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore
            };

            folderJson = JsonConvert.SerializeObject(auditConductApiReturns, settings);

            return folderJson;
        }

        public List<AuditConductApiReturnModel> GenerateConductFolderHierarchy(List<AuditConductApiReturnModel> conducts, Guid? parentConductId, int conductLevel)
        {
            return conducts.Where(x => x.ParentConductId.Equals(parentConductId)).Select(subConducts => new AuditConductApiReturnModel
            {
                AuditId = subConducts.AuditId,
                ConductId = subConducts.ConductId,
                AuditRatingId = subConducts.AuditRatingId,
                AuditRatingName = subConducts.AuditRatingName,
                ParentConductId = subConducts.ParentConductId,
                AuditConductName = subConducts.AuditConductName,
                AuditConductDescription = subConducts.AuditConductDescription,
                AuditDescription = subConducts.AuditDescription,
                IsArchived = subConducts.IsArchived,
                IsCompleted = subConducts.IsCompleted,
                IsIncludeAllQuestions = subConducts.IsIncludeAllQuestions,
                IsRAG = subConducts.IsRAG,
                IsConduct = subConducts.IsConduct,
                CanLogTime = subConducts.CanLogTime,
                InBoundPercent = subConducts.InBoundPercent,
                OutBoundPercent = subConducts.OutBoundPercent,
                TotalEstimatedTime = subConducts.TotalEstimatedTime,
                TotalSpentTime = subConducts.TotalSpentTime,
                DeadlineDate = subConducts.DeadlineDate,
                IsConductEditable = subConducts.IsConductEditable,
                ConductScore = subConducts.ConductScore,
                QuestionsCount = subConducts.QuestionsCount,
                AnsweredCount = subConducts.AnsweredCount,
                UnAnsweredCount = subConducts.UnAnsweredCount,
                ValidAnswersCount = subConducts.ValidAnswersCount,
                InValidAnswersCount = subConducts.InValidAnswersCount,
                IsConductSubmitted = subConducts.IsConductSubmitted,
                CanConductSubmitted = subConducts.CanConductSubmitted,
                AreActionsAdded = subConducts.AreActionsAdded,
                IsFromTags = subConducts.IsFromTags,
                AuditTagsModels = subConducts.AuditTagsModels,
                ConductTagsModels = subConducts.ConductTagsModels,
                CreatedUserMail = subConducts.CreatedUserMail,
                UpdatedUserMail = subConducts.UpdatedUserMail,
                ConductAssigneeMail = subConducts.ConductAssigneeMail,
                AuditResponsibleUserMail = subConducts.AuditResponsibleUserMail,
                CreatedDateTime = subConducts.CreatedDateTime,
                UpdatedByUserId = subConducts.UpdatedByUserId,
                UpdatedByUserName = subConducts.UpdatedByUserName,
                UpdatedDateTime = subConducts.UpdatedDateTime,
                CreatedByUserId = subConducts.CreatedByUserId,
                CreatedByUserName = subConducts.CreatedByUserName,
                CreatedByProfileImage = subConducts.CreatedByProfileImage,
                ResponsibleUserName = subConducts.ResponsibleUserName,
                ResponsibleProfileImage = subConducts.ResponsibleProfileImage,
                ResponsibleUserId = subConducts.ResponsibleUserId,
                TimeStamp = subConducts.TimeStamp,
                FolderTimeStamp = subConducts.FolderTimeStamp,
                ProjectId = subConducts.ProjectId,
                Status = subConducts.Status,
                StatusColor = subConducts.StatusColor,
                HaveCustomFields = subConducts.HaveCustomFields,
                AreDocumentsUploaded = subConducts.AreDocumentsUploaded,
                Children = GenerateConductFolderHierarchy(conducts, subConducts.ConductId, conductLevel + 1)
            }).ToList();
        }

        private AuditConductApiInputModel dateConversions(AuditConductApiInputModel auditConductApiInputModel)
        {
            if (auditConductApiInputModel.periodValue == "Current month")
            {
                var today = DateTime.Today;
                var month = new DateTime(today.Year, today.Month, 1);
                auditConductApiInputModel.DateTo = today;
                auditConductApiInputModel.DateFrom = month.AddDays(0);
            }
            else if (auditConductApiInputModel.periodValue == "Last month")
            {
                var today = DateTime.Today;
                var month = new DateTime(today.Year, today.Month, 1);
                auditConductApiInputModel.DateFrom = month.AddMonths(-1);
                auditConductApiInputModel.DateTo = month.AddDays(-1);
            }
            else if (auditConductApiInputModel.periodValue == "Last 3 months")
            {
                var today = DateTime.Today;
                var month = new DateTime(today.Year, today.Month, 1);
                auditConductApiInputModel.DateFrom = month.AddMonths(-2);
                auditConductApiInputModel.DateTo = today;
            }
            else if (auditConductApiInputModel.periodValue == "Last 6 months")
            {
                var today = DateTime.Today;
                var month = new DateTime(today.Year, today.Month, 1);
                auditConductApiInputModel.DateFrom = month.AddMonths(-5);
                auditConductApiInputModel.DateTo = today;
            }
            else if (auditConductApiInputModel.periodValue == "Last 12 months")
            {
                var today = DateTime.Today;
                var month = new DateTime(today.Year, today.Month, 1);
                auditConductApiInputModel.DateFrom = month.AddMonths(-11);
                auditConductApiInputModel.DateTo = today;
            }
            return auditConductApiInputModel;
        }

        public List<AuditReportApiReturnModel> GetAuditReports(AuditReportApiInputModel auditReportApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditReports", "AuditCategories Service"));

            LoggingManager.Debug(auditReportApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.SearchAduits, auditReportApiInputModel, loggedInContext);

            List<AuditReportApiReturnModel> auditReportApiReturns = _complianceAuditRepository.GetAuditReports(auditReportApiInputModel, loggedInContext, validationMessages).ToList();

            if (validationMessages.Count() > 0)
            {
                return null;
            }

            return auditReportApiReturns;
        }

        public AuditRelatedCountsApiReturnModel GetAuditRelatedCounts(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditRelatedCounts", "AuditCategories Service"));

            AuditRelatedCountsApiReturnModel auditRelatedCountsApiReturnModel = _complianceAuditRepository.GetAuditRelatedCounts(projectId, loggedInContext, validationMessages);

            if (validationMessages.Count() > 0)
            {
                return null;
            }

            return auditRelatedCountsApiReturnModel;
        }

        public List<ConductQuestionActions> GetConductQuestionsForActionLinking(Guid? projectId, string questionName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConductQuestionsForActionLinking", "AuditCategories Service"));

            List<ConductQuestionActions> auditRelatedCountsApiReturnModel = _complianceAuditRepository.GetConductQuestionsForActionLinking(projectId, questionName, loggedInContext, validationMessages);

            if (validationMessages.Count() > 0)
            {
                return null;
            }

            return auditRelatedCountsApiReturnModel;
        }

        public Guid? UpsertAuditConduct(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditConduct", "ComplianceAudit Service"));

            auditConductApiInputModel.AuditConductName = auditConductApiInputModel.AuditConductName?.Trim();

            LoggingManager.Debug(auditConductApiInputModel.ToString());

            if (auditConductApiInputModel.SelectedQuestions != null && auditConductApiInputModel.SelectedQuestions.Count > 0)
            {
                auditConductApiInputModel.SelectedQuestionsXml = Utilities.GetXmlFromObject(auditConductApiInputModel.SelectedQuestions);
            }
            else
            {
                auditConductApiInputModel.SelectedQuestionsXml = null;
            }

            if (auditConductApiInputModel.SelectedCategories != null && auditConductApiInputModel.SelectedCategories.Count > 0)
            {
                auditConductApiInputModel.SelectedCategoriesXml = Utilities.GetXmlFromObject(auditConductApiInputModel.SelectedCategories);
            }
            else
            {
                auditConductApiInputModel.SelectedCategoriesXml = null;
            }

            Guid? conductId = _complianceAuditRepository.UpsertAuditConduct(auditConductApiInputModel, loggedInContext, validationMessages);

            GenericStatusModel genericAuditConductStatusModel = _automatedWorkflowmanagementServices.GetGenericStatus(new GenericStatusModel()
            {
                ReferenceId = auditConductApiInputModel.AuditId,
                ReferenceTypeId = AppConstants.ConductsReferenceTypeId,
            }, loggedInContext, validationMessages).FirstOrDefault();

            if (genericAuditConductStatusModel != null && (genericAuditConductStatusModel.WorkFlowId != null || genericAuditConductStatusModel.WorkFlowId != Guid.Empty))
            {
                GenericStatusModel genericStatusModel = new GenericStatusModel()
                {
                    ReferenceId = conductId,
                    ReferenceTypeId = AppConstants.ConductsReferenceTypeId,
                    Status = AppConstants.DraftStatus,
                    WorkFlowId = genericAuditConductStatusModel.WorkFlowId
                };

                var genericId = _automatedWorkflowmanagementServices.UpsertGenericStatus(genericStatusModel, loggedInContext, validationMessages);
            }
            else
            {

                DefaultWorkflowModel defaultWorkflows = _automatedWorkflowmanagementServices.GetDefaultWorkFlows(loggedInContext, validationMessages).FirstOrDefault();
                if (defaultWorkflows != null && defaultWorkflows.ConductDefaultWorkflowId != null && defaultWorkflows.ConductDefaultWorkflowId != Guid.Empty)
                {
                    AuditComplianceApiInputModel auditComplianceModel = new AuditComplianceApiInputModel();
                    auditComplianceModel.AuditId = auditConductApiInputModel.AuditId;
                    var auditDetails = SearchAudits(auditComplianceModel, loggedInContext, validationMessages).FirstOrDefault();
                    if (auditDetails != null && auditDetails.EnableWorkFlowForAuditConduct == true)
                    {
                        genericAuditConductStatusModel = new GenericStatusModel()
                        {
                            ReferenceId = conductId,
                            ReferenceTypeId = AppConstants.ConductsReferenceTypeId,
                            Status = AppConstants.DraftStatus,
                            WorkFlowId = defaultWorkflows.ConductDefaultWorkflowId
                        };
                        genericAuditConductStatusModel.GenericStatusId = _automatedWorkflowmanagementServices.UpsertGenericStatus(genericAuditConductStatusModel, loggedInContext, validationMessages);
                    }

                }
            }

            GenericStatusModel genericAuditConductStatusModell = _automatedWorkflowmanagementServices.GetGenericStatus(new GenericStatusModel()
            {
                ReferenceId = conductId,
                ReferenceTypeId = AppConstants.ConductsReferenceTypeId
            }, loggedInContext, validationMessages).FirstOrDefault();

            CheckAndStartWorkflowIfAny(genericAuditConductStatusModell, loggedInContext, validationMessages);

            LoggingManager.Debug(conductId?.ToString());

            return conductId;
        }

        public Guid? ReconductAudit(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReconductAudit", "ComplianceAudit Service"));

            auditConductApiInputModel.AuditConductName = auditConductApiInputModel.AuditConductName?.Trim();

            LoggingManager.Debug(auditConductApiInputModel.ToString());

            auditConductApiInputModel.SelectedQuestions = _complianceAuditRepository.GetFailedQuestionsbyConductId(auditConductApiInputModel.ConductId, loggedInContext, validationMessages);

            if (auditConductApiInputModel.SelectedQuestions != null && auditConductApiInputModel.SelectedQuestions.Count > 0)
            {
                auditConductApiInputModel.SelectedQuestionsXml = Utilities.GetXmlFromObject(auditConductApiInputModel.SelectedQuestions);
            }
            else
            {
                auditConductApiInputModel.SelectedQuestionsXml = null;
            }

            auditConductApiInputModel.ConductId = null;
            auditConductApiInputModel.IsIncludeAllQuestions = false;
            auditConductApiInputModel.IsArchived = false;
            auditConductApiInputModel.IsCompleted = false;
            auditConductApiInputModel.CronStartDate = null;
            auditConductApiInputModel.CronEndDate = null;
            auditConductApiInputModel.CronExpression = null;

            Guid? conductId = _complianceAuditRepository.UpsertAuditConduct(auditConductApiInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertAuditCompliance, auditConductApiInputModel, loggedInContext);

            LoggingManager.Debug(conductId?.ToString());

            return conductId;
        }

        public Guid? UpsertAuditReport(AuditReportApiInputModel auditReportApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditConduct", "ComplianceAudit Service"));


            LoggingManager.Debug(auditReportApiInputModel.ToString());

            Guid? conductId = _complianceAuditRepository.UpsertAuditReport(auditReportApiInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertAuditCompliance, auditReportApiInputModel, loggedInContext);

            LoggingManager.Debug(conductId?.ToString());

            return conductId;
        }

        public Guid? UpsertAuditTags(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditTags", "ComplianceAudit Service"));

            LoggingManager.Debug(auditComplianceApiInputModel?.ToString());

            if (auditComplianceApiInputModel.AuditTagsModels != null && auditComplianceApiInputModel.AuditTagsModels.Count() > 0)
            {
                auditComplianceApiInputModel.AuditTagsModelXml = Utilities.ConvertIntoListXml(auditComplianceApiInputModel.AuditTagsModels);
            }
            else
            {
                auditComplianceApiInputModel.AuditTagsModelXml = null;
            }

            Guid? auditId = _complianceAuditRepository.UpsertAuditTags(auditComplianceApiInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(auditId?.ToString());

            return auditId;
        }

        public Guid? UpsertAuditPriority(AuditPriorityModel auditPriorityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPriority", "ComplianceAudit Service"));

            LoggingManager.Debug(auditPriorityModel?.ToString());

            if (auditPriorityModel.PriorityName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessaage = "Priority name cannot be null or empty",
                    ValidationMessageType = MessageTypeEnum.Error
                });
                return null;
            }

            Guid? priorityId = _complianceAuditRepository.UpsertAuditPriority(auditPriorityModel, loggedInContext, validationMessages);

            LoggingManager.Debug(priorityId?.ToString());

            return priorityId;
        }

        public Guid? UpsertActionCategory(ActionCategoryModel actionCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActionCategory", "ComplianceAudit Service"));

            LoggingManager.Debug(actionCategoryModel?.ToString());

            if (actionCategoryModel.ActionCategoryName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessaage = "Actioncategory name cannot be null or empty",
                    ValidationMessageType = MessageTypeEnum.Error
                });
                return null;
            }

            Guid? actionCategoryId = _complianceAuditRepository.UpsertActionCategory(actionCategoryModel, loggedInContext, validationMessages);

            LoggingManager.Debug(actionCategoryId?.ToString());

            return actionCategoryId;
        }

        public Guid? UpsertAuditRating(AuditRatingModel auditRatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditRating", "ComplianceAudit Service"));

            LoggingManager.Debug(auditRatingModel?.ToString());

            if (auditRatingModel.AuditRatingName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessaage = "AuditRating name cannot be null or empty",
                    ValidationMessageType = MessageTypeEnum.Error
                });
                return null;
            }

            Guid? auditRatingId = _complianceAuditRepository.UpsertAuditRating(auditRatingModel, loggedInContext, validationMessages);

            LoggingManager.Debug(auditRatingId?.ToString());

            return auditRatingId;
        }

        public Guid? UpsertAuditImpact(AuditImpactModel auditImpactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertImpact", "ComplianceAudit Service"));

            LoggingManager.Debug(auditImpactModel?.ToString());
            if (auditImpactModel.ImpactName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessaage = "Impact name cannot be null or empty",
                    ValidationMessageType = MessageTypeEnum.Error
                });
                return null;
            }

            Guid? impactId = _complianceAuditRepository.UpsertAuditImpact(auditImpactModel, loggedInContext, validationMessages);

            LoggingManager.Debug(impactId?.ToString());

            return impactId;
        }

        public List<AuditImpactModel> GetAuditImpact(AuditImpactModel auditImpactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAudiImpact", "ComplianceAudit Service"));

            List<AuditImpactModel> auditImpacts = _complianceAuditRepository.GetAuditImpact(auditImpactModel, loggedInContext, validationMessages);

            LoggingManager.Debug(auditImpacts?.ToString());

            return auditImpacts;
        }

        public Guid? UpsertAuditRisk(AuditRiskModel auditRiskModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditRisk", "ComplianceAudit Service"));

            LoggingManager.Debug(auditRiskModel?.ToString());
            if (auditRiskModel.RiskName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessaage = "Risk name cannot be null or empty",
                    ValidationMessageType = MessageTypeEnum.Error
                });
                return null;
            }

            Guid? impactId = _complianceAuditRepository.UpsertAuditRisk(auditRiskModel, loggedInContext, validationMessages);

            LoggingManager.Debug(impactId?.ToString());

            return impactId;
        }

        public List<AuditRiskModel> GetAuditRisk(AuditRiskModel auditRiskModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditRisk", "ComplianceAudit Service"));

            List<AuditRiskModel> auditImpacts = _complianceAuditRepository.GetAuditRisk(auditRiskModel, loggedInContext, validationMessages);

            LoggingManager.Debug(auditImpacts?.ToString());

            return auditImpacts;
        }

        public List<AuditPriorityModel> GetAuditPriority(AuditPriorityModel auditPriorityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAudiPriority", "ComplianceAudit Service"));

            List<AuditPriorityModel> auditPriorities = _complianceAuditRepository.GetAuditPriority(auditPriorityModel, loggedInContext, validationMessages);

            LoggingManager.Debug(auditPriorities?.ToString());

            return auditPriorities;
        }

        public List<AuditRatingModel> GetAuditRatings(AuditRatingModel auditRatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditRatings", "ComplianceAudit Service"));

            List<AuditRatingModel> auditRatings = _complianceAuditRepository.GetAuditRatings(auditRatingModel, loggedInContext, validationMessages);

            LoggingManager.Debug(auditRatings?.ToString());

            return auditRatings;
        }

        public List<ActionCategoryModel> GetActionCategories(ActionCategoryModel actionCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActionCategories", "ComplianceAudit Service"));

            List<ActionCategoryModel> actionCategories = _complianceAuditRepository.GetActionCategories(actionCategoryModel, loggedInContext, validationMessages);

            LoggingManager.Debug(actionCategories?.ToString());

            return actionCategories;
        }

        public List<AuditTagsModel> GetTags(string searchText, string selectedIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditTags", "ComplianceAudit Service"));


            LoggingManager.Debug(searchText);

            List<AuditTagsModel> auditTagsModels = _complianceAuditRepository.GetTags(searchText, selectedIds, loggedInContext, validationMessages);

            LoggingManager.Debug(auditTagsModels?.ToString());

            return auditTagsModels;
        }



        public List<TimeSheetApproveLineManagersOutputModel> GetConductsUserDropDown(string isBranchFilter, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConductUserDropDown", "ComplianceAudit Service"));

            bool isFilter = isBranchFilter == "audit" ? true : false;

            List<TimeSheetApproveLineManagersOutputModel> userDropDownModels = _complianceAuditRepository.GetConductsUserDropDown(isFilter, loggedInContext, validationMessages);

            LoggingManager.Debug(userDropDownModels?.ToString());

            return userDropDownModels;
        }


        public List<AuditCategoryApiReturnModel> GenerateCategoryHierarchy(List<AuditCategoryApiReturnModel> auditCategories, Guid? parentCategoryId, int categoryLevel, List<AuditQuestionsApiReturnModel> auditConductQuestions)
        {
            return auditCategories.Where(x => x.ParentAuditCategoryId.Equals(parentCategoryId)).Select(subCategories => new AuditCategoryApiReturnModel
            {
                AuditCategoryId = subCategories.AuditCategoryId,
                AuditCategoryName = subCategories.AuditCategoryName,
                ParentAuditCategoryId = subCategories.ParentAuditCategoryId,
                ParentAuditCategoryName = subCategories.ParentAuditCategoryName,
                CreatedByUserId = subCategories.CreatedByUserId,
                CreatedByUserName = subCategories.CreatedByUserName,
                TimeStamp = subCategories.TimeStamp,
                AuditCategoryDescription = subCategories.AuditCategoryDescription,
                CategoryLevel = categoryLevel,
                QuestionsCount = subCategories.QuestionsCount,
                ConductScore = subCategories.ConductScore,
                AnsweredCount = subCategories.AnsweredCount,
                ValidAnswersCount = subCategories.ValidAnswersCount,
                Order = subCategories.Order,
                Questions = auditConductQuestions.Where(x => x.AuditCategoryId.Equals(subCategories.AuditCategoryId)).ToList(),
                ConductQuestionsCount = auditConductQuestions.Where(x => x.AuditCategoryId.Equals(subCategories.AuditCategoryId)).ToList().Count(),
                SubAuditCategories = GenerateCategoryHierarchy(auditCategories, subCategories.AuditCategoryId, categoryLevel + 1, auditConductQuestions)
            }).ToList();
        }

        public List<QuestionTypeApiReturnModel> GetQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQuestionTypes", "AuditCategories Service"));

            LoggingManager.Debug(questionTypeApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAuditQuestionTypes, questionTypeApiInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<QuestionTypeApiReturnModel> questionTypes = new List<QuestionTypeApiReturnModel>();

            if (questionTypeApiInputModel.IsFromMasterQuestionType == null || questionTypeApiInputModel.IsFromMasterQuestionType == false)
            {
                questionTypes = _complianceAuditRepository.GetQuestionTypes(questionTypeApiInputModel, loggedInContext, validationMessages).ToList();
            }
            else if (questionTypeApiInputModel.IsFromMasterQuestionType == true)
            {
                questionTypes = _complianceAuditRepository.GetQuestionTypeById(questionTypeApiInputModel, loggedInContext, validationMessages).ToList();
            }

            if (questionTypes != null && questionTypes.Count() > 0)
            {
                questionTypes.ForEach(x =>
                {
                    if (x.QuestionTypeOptionsXml != null)
                    {
                        x.QuestionTypeOptions = Utilities.GetObjectFromXml<QuestionTypeOptionsModel>(x.QuestionTypeOptionsXml, "QuestionTypeOptionsModel");
                    }
                    else
                    {
                        x.QuestionTypeOptions = new List<QuestionTypeOptionsModel>();
                    }
                });
            }
            return questionTypes;
        }

        public List<QuestionTypeApiReturnModel> GetMasterQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQuestionTypes", "AuditCategories Service"));

            List<QuestionTypeApiReturnModel> questionTypes = _complianceAuditRepository.GetMasterQuestionTypes(questionTypeApiInputModel, loggedInContext, validationMessages).ToList();

            return questionTypes;
        }

        public Guid? UpsertQuestionType(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertQuestionTypes", "ComplianceAudit Service"));

            questionTypeApiInputModel.QuestionTypeName = questionTypeApiInputModel.QuestionTypeName?.Trim();

            LoggingManager.Debug(questionTypeApiInputModel.ToString());

            questionTypeApiInputModel.QuestionTypeOptionsXml = Utilities.ConvertIntoListXml(questionTypeApiInputModel.QuestionTypeOptions);

            questionTypeApiInputModel.QuestionTypeId = _complianceAuditRepository.UpsertQuestionType(questionTypeApiInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBranchCommandId, questionTypeApiInputModel, loggedInContext);

            LoggingManager.Debug(questionTypeApiInputModel.QuestionTypeId?.ToString());

            return questionTypeApiInputModel.QuestionTypeId;
        }

        public Guid? UpsertAuditQuestion(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditQuestion", "ComplianceAudit Service"));

            auditQuestionsApiInputModel.QuestionName = auditQuestionsApiInputModel.QuestionName?.Trim();

            LoggingManager.Debug(auditQuestionsApiInputModel.ToString());

            auditQuestionsApiInputModel.AuditAnswersModel = Utilities.ConvertIntoListXml(auditQuestionsApiInputModel.QuestionOptions);

            auditQuestionsApiInputModel.DocumentsModel = Utilities.ConvertIntoListXml(auditQuestionsApiInputModel.Documents);

            auditQuestionsApiInputModel.QuestionId = _complianceAuditRepository.UpsertAuditQuestion(auditQuestionsApiInputModel, loggedInContext, validationMessages);

            if (auditQuestionsApiInputModel.WorkFlowId != null && auditQuestionsApiInputModel.WorkFlowId != Guid.Empty && auditQuestionsApiInputModel.QuestionId != null && auditQuestionsApiInputModel.QuestionId != Guid.Empty)
            {
                GenericStatusModel genericStatusModel = new GenericStatusModel()
                {
                    ReferenceId = auditQuestionsApiInputModel.QuestionId,
                    ReferenceTypeId = AppConstants.AuditQuestionsReferenceTypeId,
                    Status = AppConstants.DraftStatus,
                    WorkFlowId = auditQuestionsApiInputModel.WorkFlowId
                };
                var genericStatusId = _automatedWorkflowmanagementServices.UpsertGenericStatus(genericStatusModel, loggedInContext, validationMessages);

            }
            //else if(auditQuestionsApiInputModel.QuestionId != null && auditQuestionsApiInputModel.QuestionId != Guid.Empty)
            //{
            //    AuditComplianceApiInputModel auditComplianceModel = new AuditComplianceApiInputModel();
            //    auditComplianceModel.AuditId = auditQuestionsApiInputModel.AuditId;
            //    var auditDetails = SearchAudits(auditComplianceModel, loggedInContext, validationMessages).FirstOrDefault();
            //    if(auditDetails.EnableQuestionLevelWorkFlow == true)
            //    {
            //        DefaultWorkflowModel defaultWorkflows = _automatedWorkflowmanagementServices.GetDefaultWorkFlows(loggedInContext, validationMessages).FirstOrDefault();
            //        if(defaultWorkflows.QuestionDefaultWorkflowId != null && defaultWorkflows.QuestionDefaultWorkflowId != Guid.Empty)
            //        {
            //            GenericStatusModel genericStatusModel = new GenericStatusModel()
            //            {
            //                ReferenceId = auditQuestionsApiInputModel.QuestionId,
            //                ReferenceTypeId = AppConstants.AuditQuestionsReferenceTypeId,
            //                Status = AppConstants.DraftStatus,
            //                WorkFlowId = defaultWorkflows.QuestionDefaultWorkflowId
            //            };
            //            var genericStatusId = _automatedWorkflowmanagementServices.UpsertGenericStatus(genericStatusModel, loggedInContext, validationMessages);

            //        }
            //    }
            //}
            _auditService.SaveAudit(AppCommandConstants.UpsertBranchCommandId, auditQuestionsApiInputModel, loggedInContext);

            LoggingManager.Debug(auditQuestionsApiInputModel.QuestionId?.ToString());

            return auditQuestionsApiInputModel.QuestionId;
        }

        public List<AuditQuestionsApiReturnModel> GetAuditQuestions(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditQuestions", "AuditCategories Service"));

            LoggingManager.Debug(auditQuestionsApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAuditQuestions, auditQuestionsApiInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            auditQuestionsApiInputModel.QuestionTypeFilterXml = auditQuestionsApiInputModel.QuestionTypeFilter != null && auditQuestionsApiInputModel.QuestionTypeFilter.Count > 0 ? Utilities.GetXmlFromObject(auditQuestionsApiInputModel.QuestionTypeFilter) : null;

            auditQuestionsApiInputModel.QuestionIdsXml = auditQuestionsApiInputModel.QuestionIds != null && auditQuestionsApiInputModel.QuestionIds.Count > 0 ? Utilities.GetXmlFromObject(auditQuestionsApiInputModel.QuestionIds) : null;

            List<AuditQuestionsApiReturnModel> auditQuestions = new List<AuditQuestionsApiReturnModel>();

            if (auditQuestionsApiInputModel != null && auditQuestionsApiInputModel.AuditVersionId != null)
            {
                auditQuestions = _complianceAuditRepository.GetAuditQuestionsByVersionId(auditQuestionsApiInputModel, loggedInContext, validationMessages).ToList();
            }
            else
            {
                auditQuestions = _complianceAuditRepository.GetAuditQuestions(auditQuestionsApiInputModel, loggedInContext, validationMessages).ToList();
            }

            if (auditQuestionsApiInputModel.QuestionId != null && auditQuestions != null)
            {
                auditQuestions.ForEach(x =>
                {
                    if (x.QuestionsXml != null)
                    {
                        x.QuestionOptions = Utilities.GetObjectFromXml<AuditQuestionOptions>(x.QuestionsXml, "AuditQuestionOptions");
                    }
                    else
                    {
                        x.QuestionOptions = new List<AuditQuestionOptions>();
                    }
                    if (x.QuestionFilesXml != null)
                    {
                        x.QuestionFiles = Utilities.GetObjectFromXml<FileApiReturnModel>(x.QuestionFilesXml, "FileApiReturnModel");
                    }
                    else
                    {
                        x.QuestionFiles = new List<FileApiReturnModel>();
                    }
                    if (x.DocumentsXml != null)
                    {
                        x.Documents = Utilities.GetObjectFromXml<DocumentModel>(x.DocumentsXml, "DocumentModel");
                    }
                    else
                    {
                        x.Documents = new List<DocumentModel>();
                    }
                });
            }
            return auditQuestions;
        }

        public List<AuditQuestionsApiReturnModel> SearchAuditConductQuestions(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditQuestions", "AuditCategories Service"));

            LoggingManager.Debug(auditQuestionsApiInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAuditQuestions, auditQuestionsApiInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            auditQuestionsApiInputModel.QuestionTypeFilterXml = auditQuestionsApiInputModel.QuestionTypeFilter != null && auditQuestionsApiInputModel.QuestionTypeFilter.Count > 0 ? Utilities.GetXmlFromObject(auditQuestionsApiInputModel.QuestionTypeFilter) : null;

            auditQuestionsApiInputModel.QuestionIdsXml = auditQuestionsApiInputModel.QuestionIds != null && auditQuestionsApiInputModel.QuestionIds.Count > 0 ? Utilities.GetXmlFromObject(auditQuestionsApiInputModel.QuestionIds) : null;

            List<AuditQuestionsApiReturnModel> auditQuestions = _complianceAuditRepository.SearchAuditConductQuestions(auditQuestionsApiInputModel, loggedInContext, validationMessages).ToList();

            if (auditQuestions != null && auditQuestions.Count > 0 && auditQuestions[0].CategoriesXml != null)
            {
                List<AuditCategoryApiReturnModel> auditCategories = Utilities.GetObjectFromXml<AuditCategoryApiReturnModel>(auditQuestions[0].CategoriesXml, "AuditCategoryApiReturnModel");

                var reportQuestions = new AuditQuestionsApiReturnModel
                {
                    ConductId = auditQuestions[0].ConductId,

                    ConductName = auditQuestions[0].ConductName,

                    AuditReportId = auditQuestions[0].AuditReportId,

                    //Questions = auditQuestions.Take(auditQuestions.Count > 150 ? 150 : auditQuestions.Count).ToList(),

                    QuestionsForReport = auditQuestions,

                    IsConductArchived = auditQuestions[0].IsConductArchived,

                    HierarchyTree = GenerateCategoryHierarchy(auditCategories, null, 0, auditQuestions)
                };
                auditQuestions = new List<AuditQuestionsApiReturnModel>
                {
                    reportQuestions
                };
            }

            if (auditQuestions != null)
            {
                auditQuestions.ForEach(x =>
                {
                    if (x.DocumentsXml != null)
                    {
                        x.Documents = Utilities.GetObjectFromXml<DocumentModel>(x.DocumentsXml, "DocumentModel");
                    }
                    else
                    {
                        x.Documents = new List<DocumentModel>();
                    }
                });
            }
            //if (auditQuestionsApiInputModel.QuestionId != null && auditQuestions != null)
            //{
            //    auditQuestions.ForEach(x =>
            //    {
            //        if (x.QuestionFilesXml != null)
            //        {
            //            x.QuestionFiles = Utilities.GetObjectFromXml<FileApiReturnModel>(x.QuestionFilesXml, "FileApiReturnModel");
            //        }
            //        else
            //        {
            //            x.QuestionFiles = new List<FileApiReturnModel>();
            //        }
            //    });
            //}
            return auditQuestions;
        }
        public List<ConductSelectedQuestionModel> GetQuestionsByFilters(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQuestionsByFilters", "AuditCategories Service"));

            LoggingManager.Debug(auditQuestionsApiInputModel?.ToString());

            if (auditQuestionsApiInputModel.ClearFilter == true)
            {
                return new List<ConductSelectedQuestionModel>();
            }

            _auditService.SaveAudit(AppCommandConstants.GetAuditQuestions, auditQuestionsApiInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            auditQuestionsApiInputModel.QuestionTypeFilterXml = auditQuestionsApiInputModel.QuestionTypeFilter != null && auditQuestionsApiInputModel.QuestionTypeFilter.Count > 0 ? Utilities.GetXmlFromObject(auditQuestionsApiInputModel.QuestionTypeFilter) : null;

            List<ConductSelectedQuestionModel> auditQuestions = _complianceAuditRepository.GetQuestionsByFilters(auditQuestionsApiInputModel, loggedInContext, validationMessages).ToList();

            return auditQuestions;
        }

        public List<AuditQuestionHistoryModel> GetAuditQuestionHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditQuestionHistory", "ComplianceAudit Service"));

            LoggingManager.Debug(auditQuestionHistoryModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAuditQuestions, auditQuestionHistoryModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<AuditQuestionHistoryModel> questionHistory = _complianceAuditRepository.GetAuditQuestionHistory(auditQuestionHistoryModel, loggedInContext, validationMessages).ToList();

            return questionHistory;
        }

        public List<AuditQuestionHistoryModel> UpsertAuditQuestionHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditQuestionHistory", "ComplianceAudit Service"));

            LoggingManager.Debug(auditQuestionHistoryModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAuditQuestions, auditQuestionHistoryModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<AuditQuestionHistoryModel> questionHistory = _complianceAuditRepository.UpsertAuditQuestionHistory(auditQuestionHistoryModel, loggedInContext, validationMessages).ToList();

            return questionHistory;
        }

        public List<AuditQuestionHistoryModel> GetAuditOverallHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditOverallHistory", "ComplianceAudit Service"));

            LoggingManager.Debug(auditQuestionHistoryModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAuditQuestions, auditQuestionHistoryModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(auditQuestionHistoryModel.AuditIds))
            {
                string[] auditIds = auditQuestionHistoryModel.AuditIds.Split(new[] { ',' });

                List<Guid> allAuditIds = auditIds.Select(Guid.Parse).ToList();

                auditQuestionHistoryModel.AuditsXml = Utilities.ConvertIntoListXml(allAuditIds.ToList());
            }

            if (!string.IsNullOrEmpty(auditQuestionHistoryModel.UserIds))
            {
                string[] userIds = auditQuestionHistoryModel.UserIds.Split(new[] { ',' });

                List<Guid> allUserIds = userIds.Select(Guid.Parse).ToList();

                auditQuestionHistoryModel.UserIdsXml = Utilities.ConvertIntoListXml(allUserIds.ToList());
            }

            if (!string.IsNullOrEmpty(auditQuestionHistoryModel.BranchIds))
            {
                string[] branchIds = auditQuestionHistoryModel.BranchIds.Split(new[] { ',' });

                List<Guid> allBranchIds = branchIds.Select(Guid.Parse).ToList();

                auditQuestionHistoryModel.BranchIdsXml = Utilities.ConvertIntoListXml(allBranchIds.ToList());
            }

            List<AuditQuestionHistoryModel> questionHistory = _complianceAuditRepository.GetAuditOverallHistory(auditQuestionHistoryModel, loggedInContext, validationMessages).ToList();

            return questionHistory;
        }

        public string ReorderQuestions(List<Guid> questionIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ReorderQuestions", "SearchTestCaseDetailsInputModel", questionIds, "ComplianceAudit Service"));

            string questionIdsXml;

            if (questionIds != null && questionIds.Count > 0)
            {
                questionIdsXml = Utilities.ConvertIntoListXml(questionIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReorderQuestionIds
                });

                return null;
            }

            _complianceAuditRepository.ReorderQuestions(questionIdsXml, loggedInContext, validationMessages);

            return "Success";
        }

        public string ReorderCategories(CategoryModel categoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ReorderCategories", "SearchTestCaseDetailsInputModel", categoryModel.CategoryIds, "ComplianceAudit Service"));

            string categoryIdsXml;

            if (categoryModel.CategoryIds != null && categoryModel.CategoryIds.Count > 0)
            {
                categoryIdsXml = Utilities.ConvertIntoListXml(categoryModel.CategoryIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReorderQuestionIds
                });

                return null;
            }

            _complianceAuditRepository.ReorderCategories(categoryIdsXml, categoryModel, loggedInContext, validationMessages);

            return "Success";
        }

        public Guid? CopyOrMoveQuestions(CopyMoveQuestionsModel copyMoveQuestionsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CopyOrMoveQuestions", "copyMoveQuestionsModel", copyMoveQuestionsModel, "ComplianceAudit Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            string questionIdsXml = string.Empty;


            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (copyMoveQuestionsModel.QuestionsList != null && copyMoveQuestionsModel.QuestionsList.Count > 0)
            {
                questionIdsXml = Utilities.GetXmlFromObject(copyMoveQuestionsModel.QuestionsList);
            }
            else
            {
                questionIdsXml = null;
            }

            if (copyMoveQuestionsModel.SelectedCategories != null && copyMoveQuestionsModel.SelectedCategories.Count > 0)
            {
                copyMoveQuestionsModel.SelectedCategoriesxml = Utilities.GetXmlFromObject(copyMoveQuestionsModel.SelectedCategories);
            }
            else
            {
                copyMoveQuestionsModel.SelectedCategoriesxml = null;
            }

            copyMoveQuestionsModel.QuestionsXml = questionIdsXml;

            _auditService.SaveAudit(AppCommandConstants.SearchTestSuitesCommandId, copyMoveQuestionsModel, loggedInContext);

            var testCaseId = _complianceAuditRepository.CopyOrMoveQuestions(copyMoveQuestionsModel, loggedInContext, validationMessages);

            //if (testCaseId != Guid.Empty || testCaseId != null)
            //{
            //   BackgroundJob.Enqueue(() => UpdateFolderAndStoreSizeByFolderId(testCaseId, loggedInContext));
            //}

            return validationMessages.Count > 0 ? null : testCaseId;
        }

        public Guid? MoveAuditQuestionsToAuditCategory(MoveAuditQuestionsToAuditCategoryApiInputModel moveAuditQuestionsToAuditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "MoveAuditQuestionsToAuditCategory", "ComplianceAudit Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAuditQuestions, moveAuditQuestionsToAuditCategoryApiInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            moveAuditQuestionsToAuditCategoryApiInputModel.AuditQuestionsXml = moveAuditQuestionsToAuditCategoryApiInputModel.QuestionIds != null && moveAuditQuestionsToAuditCategoryApiInputModel.QuestionIds.Count > 0 ? Utilities.GetXmlFromObject(moveAuditQuestionsToAuditCategoryApiInputModel.QuestionIds) : null;

            Guid? auditCategoryId = _complianceAuditRepository.MoveQuestionsToAuditCategory(moveAuditQuestionsToAuditCategoryApiInputModel, loggedInContext, validationMessages);

            return auditCategoryId;
        }

        public List<GetBugsBasedOnUserStoryApiReturnModel> SearchConductQuestionActions(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get actions Based on audit conduct questions", "ComplianceAudit Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchUserStoryTagsCommandId, userStorySearchCriteriaInputModel, loggedInContext);

            List<GetBugsBasedOnUserStoryApiReturnModel> userStoryModel = _complianceAuditRepository.GetActionsBasedOnAuditConductQuestion(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return userStoryModel;
        }

        public Guid? SubmitAuditConduct(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SubmitAuditConduct", "ComplianceAudit Service"));

            LoggingManager.Debug(auditConductApiInputModel.ConductId.ToString());

            Guid? auditSubmittedConductId = _complianceAuditRepository.SubmitAuditConduct(auditConductApiInputModel, loggedInContext, validationMessages);

            if (auditSubmittedConductId != null)
            {
                List<AuditQuestionsApiReturnModel> questions = SearchAuditConductQuestions(new AuditQuestionsApiInputModel { ConductId = auditConductApiInputModel.ConductId, IsMailPdf = true }, loggedInContext, validationMessages);
                var _value = GenerateConductPDFSendMail(auditConductApiInputModel.ConductId, questions[0].QuestionsForReport, loggedInContext, validationMessages);

                //GenericStatusModel genericAuditConductStatusModel = _automatedWorkflowmanagementServices.GetGenericStatus(new GenericStatusModel()
                //{
                //    ReferenceId = auditConductApiInputModel.ConductId,
                //    ReferenceTypeId = AppConstants.ConductsReferenceTypeId
                //}, loggedInContext, validationMessages).FirstOrDefault();


                ////GenericStatusModel genericStatusModel = new GenericStatusModel()
                ////{
                ////    ReferenceId = auditConductApiInputModel.ConductId,
                ////    ReferenceTypeId = AppConstants.ConductsReferenceTypeId,
                ////    Status = AppConstants.DraftStatus,
                ////    WorkFlowId = genericAuditConductStatusModel.WorkFlowId
                ////};
                ////var genericStatusId = _automatedWorkflowmanagementServices.UpsertGenericStatus(genericStatusModel, loggedInContext, validationMessages);
                ////genericStatusModel.GenericStatusId = genericStatusId;

                //CheckAndStartWorkflowIfAny(genericAuditConductStatusModel, loggedInContext, validationMessages);
            }

            return auditSubmittedConductId;
        }

        public List<SelectedQuestionModel> GetQuestionsBasedonAuditId(Guid? auditComplainceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQuestionsBasedonAuditId", "ComplianceAudit Service"));

            LoggingManager.Debug(auditComplainceId.ToString());

            List<SelectedQuestionModel> auditQuestionsList = _complianceAuditRepository.GetAuditQuestionsBasedonAuditId(auditComplainceId, loggedInContext, validationMessages);

            return auditQuestionsList;
        }

        public List<List<AuditSubmittedDetailsReturnModel>> SearchSubmittedAudits(AuditSearchInputModel auditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchSubmittedAudits", "AuditCategories Service"));

            List<AuditSubmittedDetailsReturnModel> auditComplianceApiReturnModels = _complianceAuditRepository.SearchSubmittedAudits(auditSearchInputModel, loggedInContext, validationMessages).ToList();

            var auditDetails = auditComplianceApiReturnModels.GroupBy(x => x.BranchId).Select(grp => grp.ToList()).ToList();

            return auditDetails;
        }

        public List<List<AuditSubmittedDetailsReturnModel>> SearchNonCompalintAudits(AuditSearchInputModel auditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchNonCompalintAudits", "AuditCategories Service"));

            List<AuditSubmittedDetailsReturnModel> auditComplianceApiReturnModels = _complianceAuditRepository.SearchNonCompalintAudits(auditSearchInputModel, loggedInContext, validationMessages).ToList();

            var auditDetails = auditComplianceApiReturnModels.GroupBy(x => x.QuestionId).Select(grp => grp.ToList()).ToList();

            return auditDetails;
        }

        public List<List<AuditSubmittedDetailsReturnModel>> SearchCompalintAudits(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchCompalintAudits", "AuditCategories Service"));

            List<AuditSubmittedDetailsReturnModel> auditComplianceApiReturnModels = _complianceAuditRepository.SearchCompalintAudits(loggedInContext, validationMessages).ToList();

            var auditDetails = auditComplianceApiReturnModels.GroupBy(x => x.QuestionId).Select(grp => grp.ToList()).ToList();

            return auditDetails;
        }

        public void PostMethod(AuditComplianceApiInputModel auditComplainceInputModel, CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isToIncludeAllQuestions, List<SelectedQuestionModel> auditQuestionsList)
        {
            if (cronExpressionInputModel.ConductEndDate != null && DateTime.UtcNow.Date <= cronExpressionInputModel.ConductEndDate?.Date)
            {
                if (cronExpressionInputModel.ScheduleEndDate == null || (cronExpressionInputModel.ScheduleEndDate != null && DateTime.UtcNow.Date <= cronExpressionInputModel.ScheduleEndDate?.Date))
                {
                    AuditComplianceApiReturnModel auditDetails = new AuditComplianceApiReturnModel();

                    if (auditComplainceInputModel.AuditId != null && auditComplainceInputModel.AuditId != Guid.Empty)
                    {
                        AuditComplianceApiInputModel auditComplianceModel = new AuditComplianceApiInputModel();
                        auditComplianceModel.AuditId = auditComplainceInputModel.AuditId;
                        auditDetails = SearchAudits(auditComplianceModel, loggedInContext, validationMessages).FirstOrDefault();
                        if (auditDetails != null)
                        {
                            auditDetails.UpdatedDateTime = auditDetails.UpdatedDateTime != null ? auditDetails.UpdatedDateTime : auditDetails.CreatedDateTime;
                        }
                    }

                    var today = DateTime.UtcNow;
                    if (!string.IsNullOrEmpty(loggedInContext.TimeZoneString))
                    {
                        today = TimeZoneInfo.ConvertTime(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById(loggedInContext.TimeZoneString));
                    }

                    DateTime startDate = new DateTime(cronExpressionInputModel.ConductStartDate?.Year ?? today.Year, cronExpressionInputModel.ConductStartDate?.Month ?? today.Month, cronExpressionInputModel.ConductStartDate?.Day ?? today.Day, 0, 0, 0, DateTimeKind.Utc);
                    DateTime endDate = new DateTime(today.Year, today.Month, today.Day, 23, 59, 59, DateTimeKind.Utc);

                    if (auditDetails != null && startDate < endDate)
                    {
                        var dateList = CronHelper.GenerateDates(cronExpressionInputModel.CronExpression, startDate, endDate, cronExpressionInputModel.SpanInYears ?? 0, cronExpressionInputModel.SpanInMonths ?? 0, cronExpressionInputModel.SpanInDays ?? 0);

                        if (dateList != null && dateList.Count > 0 && auditDetails != null && auditDetails.AuditQuestionsCount > 0)
                        {
                            dateList = dateList.Where(x =>
                             x.StartTime <= today && x.EndTime >= today).ToList();
                            //foreach (var date in dateList)
                            //{
                            //   if (auditList.Any(x => x.CronStartDate == date.StartTime && x.CronEndDate == date.EndTime && x.AuditId == decryptModel.AuditId))
                            //   {
                            //       dateList.Remove(date);
                            //   }
                            //}
                            foreach (var date in dateList)
                            {

                                string SelectedQuestionsXml = null;

                                if (auditQuestionsList != null && auditQuestionsList.Count > 0)
                                {
                                    SelectedQuestionsXml = Utilities.GetXmlFromObject(auditQuestionsList);
                                }
                                else
                                {
                                    SelectedQuestionsXml = null;
                                }

                                AuditConductApiInputModel conductInputModel = new AuditConductApiInputModel();
                                conductInputModel.AuditId = auditComplainceInputModel.AuditId;
                                conductInputModel.IsCompleted = false;
                                conductInputModel.IsIncludeAllQuestions = isToIncludeAllQuestions;
                                conductInputModel.SelectedQuestions = auditQuestionsList;
                                conductInputModel.SelectedQuestionsXml = SelectedQuestionsXml;
                                conductInputModel.AuditConductName = auditComplainceInputModel.AuditName;
                                conductInputModel.DeadlineDate = date.EndTime;
                                conductInputModel.CronStartDate = date.StartTime;
                                conductInputModel.CronEndDate = date.EndTime;
                                conductInputModel.CronExpression = cronExpressionInputModel.CronExpression;
                                conductInputModel.ResponsibleUserId = cronExpressionInputModel.ResponsibleUserId;

                                UpsertAuditConduct(conductInputModel, loggedInContext, validationMessages);
                            }
                        }
                    }
                }
            }
            else
            {
                RecurringJob.RemoveIfExists(cronExpressionInputModel.JobId.ToString());
            }
        }

        public async Task<string> GenerateAuditReportAndSendMail(AuditReportApiInputModel auditReportApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entering into GenrerateReportPdf Method in audits service");
            List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

            List<AuditQuestionsApiReturnModel> auditQuestions = new List<AuditQuestionsApiReturnModel>();

            if (auditReportApiInputModel.QuestionsForReport == null || auditReportApiInputModel.QuestionsForReport.Count == 0)
            {
                var auditQuestionsApiInputModel = new AuditQuestionsApiInputModel();
                auditQuestionsApiInputModel.ConductId = auditReportApiInputModel.ConductId;
                auditQuestionsApiInputModel.IsArchived = false;
                auditQuestionsApiInputModel.IsHierarchical = false;

                auditQuestions = _complianceAuditRepository.SearchAuditConductQuestions(auditQuestionsApiInputModel, loggedInContext, validationMessages).ToList();

                auditReportApiInputModel.QuestionsForReport = auditQuestions;
            }

            var userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel();
            userStorySearchCriteriaInputModel.AuditConductQuestionId = null;
            userStorySearchCriteriaInputModel.ConductId = auditReportApiInputModel.ConductId;

            List<GetBugsBasedOnUserStoryApiReturnModel> questionActions = _complianceAuditRepository.GetActionsBasedOnAuditConductQuestion(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            var logo = companyDetails != null ? companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value : "";


            string style = "@media print { div {page-break-inside: avoid;} } @page { margin-top: 5px;margin-bottom:5px }.Parent{word-break:break-all;padding:2px 5px;text-align:left;border-left-style:solid;border-color:#b0b0b0;border-width:1px;font-family:sans-serif}.header{border-bottom-style:solid;border-top-style:solid;border-color:#b0b0b0;padding:3px 0 3px 10px;background-color:#3da8b5;color:azure;font-weight:500;word-break:normal}.action{border-bottom-style:solid;border-top-style:solid;border-color:#b0b0b0;padding:3px 0 3px 10px;background-color:#d08282;color:azure;font-weight:500;word-break:normal}.last{border-right-style:solid;border-color:#b0b0b0}.bottom{border-bottom-style:solid;border-color:#b0b0b0}.Answer{padding:5px;width:78%}.count{border-radius:50%;margin-left:10px;text-align:center;height:25px;width:25px}*{-webkit-print-color-adjust:exact!important;color-adjust:exact!important}.tag{margin:10px;background-color:#3da8b5;padding:2px 5px;border-radius:5px;color:azure}.ml-05{margin-left: 5px}.mr-05{margin-right: 5px}.border-bottom{border-bottom: 1px solid #b0b0b0}";
            var PdfData = $"<html><style> { style } </style><body style=\"padding: 10px; font-family: Verdana, Geneva, Tahoma, sans-serif;font-size: 13px \">";

            PdfData += "<div style=\"display: flex; background-color: #3da8b5; color: azure;\"><div style = \"width: 80%;\"><div style = \"margin: 10px; text-align: center;word-break:break-word;\"><h2> " + auditReportApiInputModel.AuditReportName + " </h2>";

            if (!string.IsNullOrEmpty(auditReportApiInputModel.AuditReportDescription))
            {
                PdfData += "<div> ( " + auditReportApiInputModel.AuditReportDescription + " ) </div>";
            }

            PdfData += "</div>";

            PdfData += "<div style=\"margin: 10px;\">Created on " + auditReportApiInputModel.CreatedDateTime.Value.ToString("dddd, dd MMMM yyyy", new CultureInfo("en-US")) + ", by <b>" + auditReportApiInputModel.CreatedByUserName + "</b>";

            if (!string.IsNullOrEmpty(auditReportApiInputModel.AuditRatingName))
            {
                PdfData += "<br><b>Rating: " + auditReportApiInputModel.AuditRatingName + "</b>";
            }

            PdfData += "</div></div>";

            PdfData += "<div style=\"width: 20%; vertical-align: middle; position: relative; \">"
                 + "<img src = \"" + logo + "\" style = \"margin-right: 15px;max-width: 120px; max-height: 60px;position: absolute;top: 0;bottom: 0;margin: auto; \"></div></div><br> ";

            PdfData += "<div style=\"display: flex; width: 100%; \">";
            PdfData += "<div class=\"tag\">##Audit## score: <b>" + auditReportApiInputModel.ConductScore.ToString() + "</b></div>"
                         + "<div class=\"tag\">Total ##questions##: <b>" + auditReportApiInputModel.QuestionsCount.ToString() + "</b></div>"
                         + "<div class=\"tag\">Answered ##questions## count: <b>" + auditReportApiInputModel.AnsweredCount + "</b></div>"
                         + "<div class=\"tag\">Not answered ##questions## count: <b>" + auditReportApiInputModel.UnAnsweredCount + "</b></div>";
            PdfData += "</div><br>"
                         + "<div style=\"display:flex;\"><div style=\"width:16.8%;\" class=\"Parent header\"><b>##Question## Category</b></div><div style=\"width:10%;\" class=\"Parent header\"><b>##Question## Id</b></div><div style=\"width:52%\" class=\"Parent header\"><b>##Question## Title</b></div><div style=\"width:20%\" class=\"Parent header\"><b>Answer</b></div></div>";

            var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
            List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();
            if (softLabelsList.Count > 0)
            {
                if(!string.IsNullOrEmpty(softLabelsList[0].AuditLabel))
                {
                    PdfData = PdfData.Replace("##Audit##", softLabelsList[0].AuditLabel);
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].AuditQuestionLabel))
                {
                    PdfData = PdfData.Replace("##Question##", softLabelsList[0].AuditQuestionLabel);
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].AuditQuestionsLabel))
                {
                    PdfData = PdfData.Replace("##questions##", softLabelsList[0].AuditQuestionsLabel);
                }
            }

            if (auditReportApiInputModel.QuestionsForReport != null)
            {
                int questionCount = auditReportApiInputModel.QuestionsForReport.Count;
                int counter = 1;
                string auditCategoryName = "";
                string classString = "";
                string categoryName = "";
                foreach (var auditQuestionsApiReturn in auditReportApiInputModel.QuestionsForReport)
                {
                    string answer = "";
                    string name = " Unanswered ";
                    if (!string.IsNullOrEmpty(auditQuestionsApiReturn.SubmittedByUserName))
                    {
                        name = " Submitted by " + auditQuestionsApiReturn.SubmittedByUserName;
                    }
                    string color = "";

                    if (auditQuestionsApiReturn.SubmittedByUserName == null)
                    {
                        color = "#b0b0b0";
                    }
                    else if (auditQuestionsApiReturn.IsAnswerValid)
                    {
                        color = "#65bb63";
                    }
                    else
                    {
                        color = "#d97373";
                    }

                    if (auditQuestionsApiReturn.QuestionResult != null)
                    {
                        answer = auditQuestionsApiReturn.QuestionResult;
                    }
                    else if (auditQuestionsApiReturn.QuestionResultDate != null)
                    {
                        answer = auditQuestionsApiReturn.QuestionResultDate?.ToString("dd MMMM yyyy", new CultureInfo("en-US"));
                    }
                    else if (auditQuestionsApiReturn.QuestionResultNumeric != null)
                    {
                        answer = auditQuestionsApiReturn.QuestionResultNumeric.ToString();
                    }
                    else if (auditQuestionsApiReturn.QuestionResultTime != null)
                    {
                        answer = auditQuestionsApiReturn.QuestionResultTime?.ToString();
                    }
                    else if (auditQuestionsApiReturn.QuestionResultText != null)
                    {
                        answer = auditQuestionsApiReturn.QuestionResultText;
                    }
                    else
                    {
                        //answer = " Not answered";
                        answer = "&nbsp";
                    }
                    if (counter == questionCount && auditQuestionsApiReturn.ActionsCount == 0)
                    {
                        classString = "bottom";
                    }
                    else
                    {
                        classString = "";
                    }
                    if (auditCategoryName != auditQuestionsApiReturn.AuditCategoryName)
                    {
                        categoryName = auditQuestionsApiReturn.AuditCategoryName;
                        auditCategoryName = auditQuestionsApiReturn.AuditCategoryName;
                        if (auditQuestionsApiReturn.ParentAuditCategoryId != null)
                        {
                            categoryName = "" + categoryName;
                        }
                    }
                    else
                    {
                        categoryName = "";
                    }
                    var htmlBody = "<div style=\"display: flex\">"
                                      + "<div style=\"width:16.8%;font-size:12px;padding-top:8px;\" class=\"Parent " + classString + "\">" + categoryName + "</div>"
                                      + "<div style=\"width:10%;font-size:12px;padding-top:8px;\" class=\"Parent " + classString + "\">" + auditQuestionsApiReturn.QuestionIdentity + "</div>"
                                      + "<div style=\"width:52%;font-size:12px;padding-top:8px;\" class=\"Parent " + classString + "\">" + auditQuestionsApiReturn.QuestionName + "</div>"
                                      + "<div style=\"width:20%;font-size:12px;display: flex;padding-top:8px;\" class=\"Parent last " + classString + "\">"
                                            + "<div class =\"Answer\">" + answer + "</div>";
                    //if (!auditQuestionsApiReturn.IsAnswerValid)
                    //{
                    //    htmlBody += "<div class =\"count\" style=\"background-color:#d97373;position:relative\"><span style=\"position:absolute;top:5px;right:9px\">" + auditQuestionsApiReturn.ActionsCount + "</span></div>";
                    //}

                    if (auditQuestionsApiReturn.ActionsCount > 0 && auditQuestionsApiReturn.ActionsCount < 10)
                    {
                        htmlBody += "<div class =\"count\" style=\"background-color:#d97373;position:relative\"><span style=\"position:absolute;top:5px;right:9px\">" + auditQuestionsApiReturn.ActionsCount + "</span></div>";
                    }

                    if (auditQuestionsApiReturn.ActionsCount > 9)
                    {
                        htmlBody += "<div class =\"count\" style=\"background-color:#d97373;position:relative\"><span style=\"position:absolute;top:5px;right:6px\">" + auditQuestionsApiReturn.ActionsCount + "</span></div>";
                    }

                    htmlBody += "</div></div>";
                    PdfData = PdfData + htmlBody;

                    int actionCounter = 1;

                    if (questionActions != null && questionActions.Count > 0 && auditQuestionsApiReturn.ActionsCount > 0)
                    {
                        string actionParentClassString = "";
                        string actionChildClassString = "";


                        PdfData = PdfData + "<div style=\"display:flex;border-left:1px solid #b0b0b0;border-right:1px solid #b0b0b0;\"><div style=\"width:16.4%\" class=\"Parent action ml-05\"><b>Action Assignee</b></div><div style=\"width:10.2%\" class=\"Parent action\"><b>Priority</b></div><div style=\"width:53.3%;\" class=\"Parent action\"><b>Action Title</b></div><div style=\"width:20%\" class=\"Parent action mr-05\"><b>Deadline</b></div></div>";
                        //PdfData = PdfData + "<div style=\"display:flex;border-left:1px solid #b0b0b0;border-right:1px solid #b0b0b0;\"><div style=\"width:16%\" class=\"Parent action ml-05\"><b>Action Assignee</b></div><div style=\"width:9.9%\" class=\"Parent action\"><b>Priority</b></div><div style=\"width:43%;\" class=\"Parent action\"><b>Action Title</b></div><div style =\"width:12%\" class=\"Parent action\"><b>Status</b></div><div style=\"width:15%\" class=\"Parent action mr-05\"><b>Deadline</b></div></div>";

                        foreach (var action in questionActions.Where(P => P.AuditConductQuestionId == auditQuestionsApiReturn.AuditConductQuestionId))
                        {
                            if (counter == questionCount && actionCounter == auditQuestionsApiReturn.ActionsCount)
                            {
                                actionParentClassString = "border-bottom";
                                actionChildClassString = "";
                            }
                            else
                            {
                                actionParentClassString = "";
                                actionChildClassString = "bottom";
                            }

                            PdfData = PdfData + "<div style=\"display: flex;border-left: 1px solid #b0b0b0;border-right:1px solid #b0b0b0;\" class=\"" + actionParentClassString + "\">"
                                          + "<div style=\"width:16.4%; font-size:12px;padding:5px\" class=\"Parent ml-05 " + actionChildClassString + "\">" + action.OwnerName + "</div>"
                                          + "<div style =\"width:10.2%;font-size:12px;padding:5px\" class=\"Parent " + actionChildClassString + "\">" + action.BugPriorityName + "</div>"
                                          + "<div style=\"width:53.3%;font-size:12px;padding:5px\" class=\"Parent " + actionChildClassString + "\">" + action.UserStoryName + "</div>"
                                          + "<div style=\"width:20%;font-size:12px;padding:5px;margin-right:4px\" class=\"Parent last " + actionChildClassString + "\">"
                                          + action.DeadLineDate.Value.ToString("dd MMMM yyyy", new CultureInfo("en-US")) + "</div></div>";

                            //PdfData = PdfData + "<div style=\"display: flex;border-left: 1px solid #b0b0b0;border-right:1px solid #b0b0b0;\" class=\"" + actionParentClassString + "\">"
                            //              + "<div style=\"width:16%; font-size:12px;padding:5px\" class=\"Parent ml-05 " + actionChildClassString + "\">" + action.OwnerName + "</div>"
                            //              + "<div style =\"width:9.9%;font-size:12px;padding:5px\" class=\"Parent " + actionChildClassString + "\">" + action.BugPriorityName + "</div>"
                            //              + "<div style=\"width:43%;font-size:12px;padding:5px\" class=\"Parent " + actionChildClassString + "\">" + action.UserStoryName + "</div>"
                            //              //+ "<div style=\"width:12%;font-size:12px;padding:5px;background-color:" + action.StatusHexValue + "\" class=\"Parent " + actionChildClassString + "\">" + action.Status + "</div>"
                            //              + "<div style=\"width:12%;font-size:12px;padding:5px;\" class=\"Parent " + actionChildClassString + "\">" + action.Status + "</div>"
                            //              + "<div style=\"width:15%;font-size:12px;padding:5px;margin-right:4px\" class=\"Parent last " + actionChildClassString + "\">"
                            //              + action.DeadLineDate.Value.ToString("dd MMMM yyyy", new CultureInfo("en-US")) + "</div></div>";
                            //PdfData = PdfData + htmlBody;
                            actionCounter++;
                        }
                    }
                    counter++;
                }
            }

            //if (questionActions != null && questionActions.Count > 0)
            //{
            //    PdfData = PdfData + "<div style=\"display:flex;margin-top:1.5rem\"><div style=\"width:17%;\" class=\"Parent header\"><b>Action Id</b></div><div style=\"width:13%\" class=\"Parent header\"><b>Priority</b></div><div style=\"width:50%\" class=\"Parent header\"><b>Action Title</b></div><div style=\"width:20%\" class=\"Parent header\"><b>Deadline</b></div></div>";

            //    foreach (var action in questionActions)
            //    {
            //        var htmlBody = "<div style=\"display: flex\">"
            //                      + "<div style=\"width:17%; font-size:12px;\" class=\"Parent bottom\">" + action.UserStoryUniqueName + "</div>"
            //                      + "<div style =\"width:13%;font-size:12px;\" class=\"Parent bottom\">"
            //                                + "<div class =\"Answer\">" + action.BugPriorityName + "</div></div>"
            //                      + "<div style=\"width:50%;font-size:12px;\" class=\"Parent bottom\">" + action.UserStoryName + "</div>"
            //                      + "<div style=\"width:20%;font-size:12px;\" class=\"Parent bottom last\">"
            //                      + action.DeadLineDate.Value.ToString("dd MMMM yyyy", new CultureInfo("en-US")) + "</div></div>";
            //        PdfData = PdfData + htmlBody;
            //    }
            //}

            PdfData = PdfData + "</body>"
                              + "</html>";

            var fileName = auditReportApiInputModel.AuditReportName + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year +
                           "-Reports.pdf";

            LoggingManager.Info("Generated html realted to Pdf File and stored as " + fileName + " in Reports service");

            if (auditReportApiInputModel.IsToSendMail)
            {
                auditReportApiInputModel.IsForMail = true;
                auditReportApiInputModel.IsForPdf = false;
            }
            else
            {
                auditReportApiInputModel.IsForMail = false;
                auditReportApiInputModel.IsForPdf = true;
            }

            //List<AuditReportApiReturnModel> auditReportApiReturns = _complianceAuditRepository.GetAuditReports(auditReportApiInputModel, loggedInContext, validationMessages).ToList();

            var pdfOutput = await _chromiumService.GeneratePdf(PdfData, auditReportApiInputModel.AuditReportName, null);

            if (auditReportApiInputModel.IsToSendMail)
            {
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

                Stream stream = new MemoryStream(pdfOutput.ByteStream);

                List<Stream> fileStream = new List<Stream>();

                fileStream.Add(stream);

                var toEmails = (auditReportApiInputModel.TO == null || auditReportApiInputModel.TO.Trim() == "") ? null : auditReportApiInputModel.TO.Trim().Split('\n');
                var ccEmails = (auditReportApiInputModel.CC == null || auditReportApiInputModel.CC.Trim() == "") ? null : auditReportApiInputModel.CC.Trim().Split('\n');
                var bccEmails = (auditReportApiInputModel.BCC == null || auditReportApiInputModel.BCC.Trim() == "") ? null : auditReportApiInputModel.BCC.Trim().Split('\n');

                var pdfHtml = _goalRepository.GetHtmlTemplateByName("AuditReportMailTemplate", loggedInContext.CompanyGuid).Replace("##PdfUrl##", pdfOutput.BlobUrl).Replace("##ReportName##", auditReportApiInputModel.AuditReportName);

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = toEmails,
                        HtmlContent = pdfHtml,
                        Subject = "Snovasys Business Suite: Audit Report of " + auditReportApiInputModel.AuditReportName,
                        CCMails = ccEmails,
                        BCCMails = bccEmails,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                });

                return pdfOutput.BlobUrl;
            }

            return pdfOutput.BlobUrl;
        }

        public async Task<string> GenerateConductPDFSendMail(Guid? conductId, List<AuditQuestionsApiReturnModel> questionsForReport, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {

                LoggingManager.Info("Entering into GenrerateReportPdf Method in audits service");
                List<CompanySettingsSearchOutputModel> companyDetails = _masterDataManagementService.GetCompanySettings(new CompanySettingsSearchInputModel(), loggedInContext, validationMessages);

                var logo = companyDetails != null ? companyDetails.Where(x => x.Key == "MainLogo").FirstOrDefault().Value : "";

                AuditConductApiReturnModel auditConductApiReturns = _complianceAuditRepository.SearchAuditConducts(new AuditConductApiInputModel { IsArchived = false, ConductId = conductId }, loggedInContext, validationMessages).FirstOrDefault();

                string style = ".Parent{word-break:break-all;padding:2px 5px;text-align:left;font-size:17px;border-left-style:solid;border-color:#b0b0b0;border-width:1px;font-family:sans-serif}.header{border-bottom-style:solid;border-top-style:solid;border-color:#b0b0b0;padding:3px 0 3px 10px;background-color:#3da8b5;color:azure;font-weight:500;word-break:normal}.last{border-right-style:solid;border-color:#b0b0b0}.bottom{border-bottom-style:solid;border-color:#b0b0b0}.Answer{padding:5px;width:78%}.count{border-radius:50%;margin-left:10px;text-align:center;height:25px;width:25px}.tag{margin:10px;background-color:#3da8b5;padding:2px 5px;border-radius:5px;color:azure}";
                var PdfData = $"<html><style> { style } </style><body style=\"padding: 10px; font-family: Verdana, Geneva, Tahoma, sans-serif;font-size: 14px \">";

                PdfData += "<div style=\"display: flex; background-color: #3da8b5; color: azure;\"><div style = \"width: 80%;\"><h2 style = \"margin: 10px; text-align: center;\"> " + auditConductApiReturns.AuditConductName + " </h2>";

                PdfData += "<div style=\"margin: 10px;\">Submitted on " + auditConductApiReturns.UpdatedDateTime.Value.ToString("dddd, dd MMMM yyyy", new CultureInfo("en-US")) + ", by <b>" + auditConductApiReturns.UpdatedByUserName + "</b> </div></div>";

                PdfData += "<div style=\"width: 20%; vertical-align: middle; position: relative; \">"
                     + "<img src = \"" + logo + "\" style = \"margin-right: 15px;max-width: 120px; max-height: 60px;position: absolute;top: 0;bottom: 0;margin: auto; \"></div></div><br> ";

                PdfData += "<div style=\"display: flex; width: 100%; \">";
                PdfData += "<div class=\"tag\">Audit score: <b>" + auditConductApiReturns.ConductScore.ToString() + "</b></div>"
                             + "<div class=\"tag\">Total questions: <b>" + auditConductApiReturns.QuestionsCount.ToString() + "</b></div>"
                             + "<div class=\"tag\">Answered questions count: <b>" + auditConductApiReturns.AnsweredCount + "</b></div>"
                             + "<div class=\"tag\">Not answered questions count: <b>" + auditConductApiReturns.UnAnsweredCount + "</b></div>";
                PdfData += "</div><br>"
                             + "<div style=\"display:flex;\"><div style=\"width:17%;\" class=\"Parent header\"><b>Question Category</b></div><div style=\"width:13%;\" class=\"Parent header\"><b>Question Id</b></div><div style=\"width:50%\" class=\"Parent header\"><b>Question Title</b></div><div style=\"width:20%\" class=\"Parent header\"><b>Answer</b></div></div>";
                if (questionsForReport != null)
                {
                    int questionCount = questionsForReport.Count;
                    int counter = 1;
                    string auditCategoryName = "";
                    string classString = "";
                    string categoryName = "";
                    foreach (var auditQuestionsApiReturn in questionsForReport)
                    {
                        string answer = "";
                        string name = " Unanswered ";
                        if (!string.IsNullOrEmpty(auditQuestionsApiReturn.SubmittedByUserName))
                        {
                            name = " Submitted by " + auditQuestionsApiReturn.SubmittedByUserName;
                        }
                        string color = "";

                        if (auditQuestionsApiReturn.SubmittedByUserName == null)
                        {
                            color = "#b0b0b0";
                        }
                        else if (auditQuestionsApiReturn.IsAnswerValid)
                        {
                            color = "#65bb63";
                        }
                        else
                        {
                            color = "#d97373";
                        }

                        if (auditQuestionsApiReturn.QuestionResult != null)
                        {
                            answer = auditQuestionsApiReturn.QuestionResult;
                        }
                        else if (auditQuestionsApiReturn.QuestionResultDate != null)
                        {
                            answer = auditQuestionsApiReturn.QuestionResultDate?.ToString("dd MMMM yyyy", new CultureInfo("en-US"));
                        }
                        else if (auditQuestionsApiReturn.QuestionResultNumeric != null)
                        {
                            answer = auditQuestionsApiReturn.QuestionResultNumeric.ToString();
                        }
                        else if (auditQuestionsApiReturn.QuestionResultTime != null)
                        {
                            answer = auditQuestionsApiReturn.QuestionResultTime?.ToString();
                        }
                        else if (auditQuestionsApiReturn.QuestionResultText != null)
                        {
                            answer = auditQuestionsApiReturn.QuestionResultText;
                        }
                        else
                        {
                            //answer = " Not answered";
                            answer = "&nbsp";
                        }
                        if (counter == questionCount)
                        {
                            classString = "bottom";
                        }
                        else
                        {
                            classString = "";
                        }
                        if (auditCategoryName != auditQuestionsApiReturn.AuditCategoryName)
                        {
                            categoryName = auditQuestionsApiReturn.AuditCategoryName;
                            auditCategoryName = auditQuestionsApiReturn.AuditCategoryName;
                            if (auditQuestionsApiReturn.ParentAuditCategoryId != null)
                            {
                                categoryName = "&nbsp&nbsp" + categoryName;
                            }
                        }
                        else
                        {
                            categoryName = "";
                        }
                        var htmlBody = "<div style=\"display: flex\">"
                                          + "<div style=\"width:17%;font-size:12px;\" class=\"Parent " + classString + "\">" + categoryName + "</div>"
                                          + "<div style=\"width:13%;font-size:12px;\" class=\"Parent " + classString + "\">" + auditQuestionsApiReturn.QuestionIdentity + "</div>"
                                          + "<div style=\"width:50%;font-size:12px;\" class=\"Parent " + classString + "\">" + auditQuestionsApiReturn.QuestionName + "</div>"
                                          + "<div style=\"width:20%;font-size:12px; display: flex\" class=\"Parent last " + classString + "\">"
                                                + "<div class =\"Answer\">" + answer + "</div>";
                        if (!auditQuestionsApiReturn.IsAnswerValid)
                        {
                            htmlBody += "<div class =\"count\" style=\"background-color:#d97373\">" + auditQuestionsApiReturn.ActionsCount + "</div>";
                        }
                        htmlBody += "</div></div>";
                        PdfData = PdfData + htmlBody;
                        counter++;
                    }
                }

                var userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel();
                userStorySearchCriteriaInputModel.AuditConductQuestionId = null;
                userStorySearchCriteriaInputModel.ConductId = auditConductApiReturns.ConductId;

                List<GetBugsBasedOnUserStoryApiReturnModel> questionActions = _complianceAuditRepository.GetActionsBasedOnAuditConductQuestion(userStorySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

                if (questionActions != null && questionActions.Count > 0)
                {
                    PdfData = PdfData + "<div style=\"display:flex;margin-top:1.5rem\"><div style=\"width:17%;\" class=\"Parent header\"><b>Action Id</b></div><div style=\"width:13%\" class=\"Parent header\"><b>Priority</b></div><div style=\"width:50%\" class=\"Parent header\"><b>Action Title</b></div><div style=\"width:20%\" class=\"Parent header\"><b>Deadline</b></div></div>";

                    foreach (var action in questionActions)
                    {
                        var htmlBody = "<div style=\"display: flex\">"
                                      + "<div style=\"width:17%; font-size:12px;\" class=\"Parent bottom\">" + action.UserStoryUniqueName + "</div>"
                                      + "<div style =\"width:13%;font-size:12px;\" class=\"Parent bottom\">"
                                                + "<div class =\"Answer\">" + action.BugPriorityName + "</div></div>"
                                      + "<div style=\"width:50%;font-size:12px;\" class=\"Parent bottom\">" + action.UserStoryName + "</div>"
                                      + "<div style=\"width:20%;font-size:12px;\" class=\"Parent bottom last\">"
                                      + action.DeadLineDate.Value.ToString("dd MMMM yyyy", new CultureInfo("en-US")) + "</div></div>";
                        PdfData = PdfData + htmlBody;
                    }
                }

                PdfData = PdfData + "</body>"
                                  + "</html>";

                var fileName = auditConductApiReturns.AuditConductName + DateTime.Now.Day + "-" + DateTime.Now.Month + DateTime.Now.Year +
                               "-Reports.pdf";

                LoggingManager.Info("Generated html realted to Pdf File and stored as " + fileName + " in Reports service");



                // List<AuditReportApiReturnModel> auditReportApiReturns = _complianceAuditRepository.GetAuditReports(auditReportApiInputModel, loggedInContext, validationMessages).ToList();

                var pdfOutput = await _chromiumService.GeneratePdf(PdfData, auditConductApiReturns.AuditConductName, null);


                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

                Stream stream = new MemoryStream(pdfOutput.ByteStream);

                List<Stream> fileStream = new List<Stream>();

                fileStream.Add(stream);

                var pdfHtml = _goalRepository.GetHtmlTemplateByName("AuditReportMailTemplate", loggedInContext.CompanyGuid).Replace("##PdfUrl##", pdfOutput.BlobUrl).Replace("##ReportName##", auditConductApiReturns.AuditConductName);

                string[] toEmails = new string[2];
                if (auditConductApiReturns.CreatedUserMail == auditConductApiReturns.UpdatedUserMail)
                {
                    toEmails[0] = auditConductApiReturns.CreatedUserMail;
                }
                else
                {
                    toEmails[0] = auditConductApiReturns.CreatedUserMail;
                    toEmails[1] = auditConductApiReturns.UpdatedUserMail;
                }

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = toEmails,
                        HtmlContent = pdfHtml,
                        Subject = "Snovasys Business Suite: Audit Report of " + auditConductApiReturns.AuditConductName,
                        // CCMails = ccEmails,
                        //BCCMails = bccEmails,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                });

                return pdfOutput.BlobUrl;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateConductPDFSendMail", "ComplianceAuditService ", exception.Message), exception);

                return null;
            }
        }

        public void AuditConductMailNotification(string procedure)
        {
            List<AuditConductMailNotificationModel> auditConductApiReturn = _complianceAuditRepository.AuditConductMailNotification(procedure);
            var validationMessages = new List<ValidationMessage>();
            if (auditConductApiReturn.Count > 0)
            {
                foreach (var auidtConduct in auditConductApiReturn)
                {
                    LoggedInContext loggedInContext = new LoggedInContext
                    {
                        LoggedInUserId = auidtConduct.UserId
                    };
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), HttpContext.Current.Request.Url.Authority);

                    string html = "<html><body>The conduct " + auidtConduct.AuditConductName + " is going to be ended today. Please check and complete.</body></html>";

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = new string[] { auidtConduct.CreatedUserMail },
                            HtmlContent = html,
                            Subject = "Snovasys Business Suite: Conduct " + auidtConduct.AuditConductName + " near to overdue",
                            // CCMails = ccEmails,
                            //BCCMails = bccEmails,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });
                }
            }

        }

        public void AuditConductStartMailNotification()
        {
            var validationMessages = new List<ValidationMessage>();
            //UserDbEntity owner = _userRepository.GetUserDetailsByName("Snovasys.Support@Support").FirstOrDefault();
            //    LoggedInContext loggedInContext = new LoggedInContext
            //    {
            //        LoggedInUserId = owner.Id,
            //        CompanyGuid = owner.CompanyId
            //    };
            List<CompanyOutputModel> companies = _companyStructureRepository.SearchCompanies(new CompanySearchCriteriaInputModel() { ForSuperUser = true }, validationMessages);
            if (companies != null && companies.Count > 0)
            {
                foreach (var c in companies)
                {
                    var owner = _userRepository.GetUserDetailsByName(c.WorkEmail, true).FirstOrDefault();
                    if (owner != null)
                    {
                        LoggedInContext loggedincontext = new LoggedInContext
                        {
                            LoggedInUserId = owner.Id,
                            CompanyGuid = owner.CompanyId
                        };
                        var workflowModel = new WorkFlowTriggerModel
                        {
                            ReferenceTypeId = AppConstants.GenericMailReferenceTypeId

                        };
                        var workflowTrigger = _automatedWorkflowmanagementServices.GetWorkFlowTriggers(workflowModel, loggedincontext, validationMessages).FirstOrDefault();
                        if (workflowTrigger != null)
                        {
                            workflowTrigger.IsForAuditRecurringMail = true;
                            //_automatedWorkflowmanagementServices.StartWorkflowProcessInstance(workflowTrigger, loggedincontext, validationMessages);
                        }
                    }
                }
            }
        }

        public void AuditConductDeadLineMailNotification()
        {
            var validationMessages = new List<ValidationMessage>();
            //UserDbEntity owner = _userRepository.GetUserDetailsByName("Snovasys.Support@Support").FirstOrDefault();
            //    LoggedInContext loggedInContext = new LoggedInContext
            //    {
            //        LoggedInUserId = owner.Id,
            //        CompanyGuid = owner.CompanyId
            //    };
            List<CompanyOutputModel> companies = _companyStructureRepository.SearchCompanies(new CompanySearchCriteriaInputModel() { ForSuperUser = true }, validationMessages);
            if (companies != null && companies.Count > 0)
            {
                foreach (var c in companies)
                {
                    var owner = _userRepository.GetUserDetailsByName(c.WorkEmail, true).FirstOrDefault();
                    if (owner != null)
                    {
                        LoggedInContext loggedincontext = new LoggedInContext
                        {
                            LoggedInUserId = owner.Id,
                            CompanyGuid = owner.CompanyId
                        };
                        var workflowModel = new WorkFlowTriggerModel
                        {
                            ReferenceTypeId = AppConstants.GenericMailReferenceTypeId

                        };
                        var workflowTrigger = _automatedWorkflowmanagementServices.GetWorkFlowTriggers(workflowModel, loggedincontext, validationMessages).FirstOrDefault();
                        if (workflowTrigger != null)
                        {
                            workflowTrigger.IsForAuditDeadLineRecurringMail = true;
                            _automatedWorkflowmanagementServices.StartWorkflowProcessInstance(workflowTrigger, loggedincontext, validationMessages);
                        }
                    }
                }
            }
        }

        public List<AuditConductMailNotificationModel> GetRecurringAuditsForSendingMails(int days, Guid? userId)
        {
            return _complianceAuditRepository.AuditConductMailNotification("USP_AuditConductStartMailNotification", days, userId);
        }

        public List<AuditConductMailNotificationModel> GetRecurringAuditsForSendingDeadLineMails(int days, Guid? userId)
        {
            return _complianceAuditRepository.AuditConductMailNotification("USP_AuditConductDeadLineMailNotification", days, userId);
        }

        public bool SendConductLinkToMails(ConductLinkEmailSendModel model, LoggedInContext loggedInContext, List<ValidationMessage> ValidationMessages)
        {
            var validationMessage = new List<ValidationMessage>();
            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), HttpContext.Current.Request.Url.Authority);


            string style = "* {- webkit - font - smoothing: antialiased;}body {Margin: 0; padding: 0; min - width: 100 %; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased; mso - line - height - rule: exactly;}table {border - spacing: 0; color: #333333;font-family: Arial, sans-serif;}img { border: 0;}.wrapper { width: 100 %; table - layout: fixed; -webkit - text - size - adjust: 100 %; -ms - text - size - adjust: 100 %;}.webkit { max - width: 600px;}.outer { Margin: 0 auto; width: 100 %; max - width: 600px;}.full - width - image img{width: 100 %; max - width: 600px; height: auto;}.inner { padding: 10px;}p { Margin: 0; padding - bottom: 10px;}.h1 { font - size: 21px; font - weight: bold; Margin - top: 15px; Margin - bottom: 5px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.h2 { font - size: 18px; font - weight: bold; Margin - top: 10px; Margin - bottom: 5px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}";
            style += ".one - column.contents { text - align: left; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.one - column p{    font - size: 14px; Margin - bottom: 10px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.two - column { text - align: center; font - size: 0;                }.two - column.column { width: 100 %; max - width: 300px; display: inline - block; vertical - align: top;                }.contents { width: 100 %;                }.two - column.contents { font - size: 14px; text - align: left;                }.two - column img{    width: 100 %; max - width: 280px; height: auto;}.two - column.text { padding - top: 10px;                }.three - column { text - align: center; font - size: 0; padding - top: 10px; padding - bottom: 10px;                }.three - column.column { width: 100 %; max - width: 200px; display: inline - block; vertical - align: top;                }.three - column.contents { font - size: 14px; text - align: center;                }.three - column img{    width: 100 %; max - width: 180px; height: auto;}.three - column.text { padding - top: 10px;                }.img - align - vertical img{    display: inline - block; vertical - align: middle;}@@media only screen and(max-device - width: 480px) { table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}";
            var html = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />";
            html += "<style type=\"text/css\">* {-webkit-font-smoothing: antialiased;}body {Margin: 0;padding: 0;min-width: 100%;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;mso-line-height-rule: exactly;}";
            html += "table {border-spacing: 0;color: #333333;font-family: Arial, sans-serif;}img {border: 0;}.wrapper { width: 100%;table-layout: fixed;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}.webkit { max-width: 600px;}.outer {Margin: 0 auto;width: 100%;max-width: 600px;}.full-width-image img {width: 100%;max-width: 600px; height: auto;}.inner { padding: 10px;}p {Margin: 0;padding-bottom: 10px;}.h1 { font-size: 21px;font-weight: bold; Margin-top: 15px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.h2 {font-size: 18px;font-weight: bold;Margin-top: 10px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column .contents {text-align: left;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column p {font-size: 14px;Margin-bottom: 10px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.two-column {text-align: center;font-size: 0;}.two-column .column {width: 100%;max-width: 300px;display: inline-block;vertical-align: top;}.contents {width: 100%;}.two-column .contents {font-size: 14px;text-align: left;}.two-column img {width: 100%;max-width: 280px;height: auto;}.two-column .text {padding-top: 10px;}.three-column {text-align: center;font-size: 0;padding-top: 10px;padding-bottom: 10px;}.three-column .column {width: 100%;max-width: 200px;display: inline-block;vertical-align: top;}.three-column .contents {font-size: 14px;text-align: center;}.three-column img {width: 100%;max-width: 180px;height: auto;}.three-column .text {padding-top: 10px;}.img-align-vertical img {display: inline-block;vertical-align: middle;}@@media only screen and (max-device-width: 480px) {table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}</style></head><bodystyle=\"Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;\"><center class=\"wrapper\"style=\"width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color:#f3f2f0;\"bgcolor=\"#f3f2f0;\"><tr><td width=\"100%\"><div class=\"webkit\" style=\"max-width:600px;Margin:0 auto;\"><table class=\"outer\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"style=\"border-spacing:0;Margin:0 auto;width:100%;max-width:600px;\"><tr><td style=\"padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;\"><table class=\"one-column\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"style=\"border-spacing:0; border-left:1px solid #e8e7e5; ";
            html += "border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5\"bgcolor=\"#FFFFFF\"><tr><td align=\"left\" style=\"padding:50px 50px 50px 50px\"><p style=\"color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif\"><h2>Dear,</h2></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future. <a target=\"_blank\" href=\"##PdfUrl##\" style=\"color: #099\">Here</a> there is the link to conduct " + model.ConductName + " audit. Please navigate and complete.<br /><br /></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Best Regards, <br />##footerName##</p></td></tr></table></td></tr></table></div></td></tr></table></center></body></html>";
            //var url = HttpContext.Current.Request.Url.Authority + "/audits/" + model.ConductId + "/conduct";
            var url = HttpContext.Current.Request.Url.Authority + "/projects/conduct/" + model.ConductId;
            var htmlTemplate = html.Replace("##PdfUrl##", url);

            var emails = new List<string>();

            var toEmails = (model.ToMails == null || model.ToMails.Trim() == "") ? null : model.ToMails.Trim().Split('\n');

            if (toEmails != null)
            {
                emails.AddRange(toEmails);
            }

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = emails.ToArray(),
                    HtmlContent = htmlTemplate,
                    Subject = "Snovasys Business Suite:" + model.ConductName + " conduct link",
                    // CCMails = ccEmails,
                    //BCCMails = bccEmails,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            });
            return true;

        }

        public bool UploadConductsFromCsv(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {

                var httpRequest = HttpContext.Current.Request;

                var loaded = UploadConductFromCsv(projectId, httpRequest, loggedInContext, validationMessages);
                return loaded;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadConductsFromCsv", "ComplianceAuditService ", exception.Message), exception);

                throw;
            }

        }
        public bool UploadConductFromCsv(Guid? projectId, HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (TextReader fileReader = new StreamReader(httpRequest.InputStream))
            {
                fileReader.ReadLine(); //to skip the first line
                var csvReader = new CsvReader(fileReader);
                csvReader.Configuration.MissingFieldFound = null;
                csvReader.Configuration.BadDataFound = null;
                csvReader.Configuration.HasHeaderRecord = false;
                List<AuditConductImportModel> auditÇonductRecords = csvReader.GetRecords<AuditConductImportModel>().ToList();
                var skipCount = auditÇonductRecords.FindIndex(x => x.AuditConductName.Contains("AuditConductName"));

                List<ValidationMessage> validations = new List<ValidationMessage>();

                if (skipCount != -1)
                {
                    skipCount = skipCount + 1;
                }
                else
                {
                    var staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format("Invalid file format. Choose correct file."),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    //throw new Exception("Invalid Csv file");
                    return false;
                }

                var conductName = auditÇonductRecords.Skip(skipCount).FirstOrDefault()?.AuditConductName;
                if (string.IsNullOrEmpty(conductName))
                {
                    var staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format("Conduct name should not be empty."),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    return false;
                }

                var auditComplianceApiInputModel = new AuditComplianceApiInputModel()
                {
                    AuditName = conductName?.Trim(),
                    IsArchived = false,
                    ProjectId = projectId
                };

                AuditComplianceApiReturnModel auditSearchResults = SearchAudits(auditComplianceApiInputModel, loggedInContext, validations).FirstOrDefault();

                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadConductsFromCsv", "Conduct", "Unable to upsert conduct with the name " + conductName + " trying to update if available"));
                    validationMessages.AddRange(validations);
                    return false;
                }
                else if (auditSearchResults == null)
                {
                    var staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format("No audit found with the name {0}.", conductName),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    return false;
                }

                Task.Factory.StartNew(() =>
                {
                    string categoryName = string.Empty;
                    foreach (var conduct in auditÇonductRecords.Skip(skipCount))
                    {
                        if (!(string.IsNullOrEmpty(conduct.Category) || string.IsNullOrWhiteSpace(conduct.Category)))
                        {
                            categoryName = conduct.Category;
                        }
                        if (string.IsNullOrEmpty(conduct.Category) || string.IsNullOrWhiteSpace(conduct.Category))
                        {
                            conduct.Category = categoryName;
                        }
                    }


                    AuditCategoryApiInputModel auditCategoryApiReturnModel = new AuditCategoryApiInputModel();
                    auditCategoryApiReturnModel.AuditId = auditSearchResults.AuditId;
                    var categories = SearchAuditCategories(auditCategoryApiReturnModel, loggedInContext, validations);
                    var subCategories = new List<AuditCategoryApiReturnModel>();
                    foreach (var c in categories)
                    {
                        if (c.SubAuditCategories.Count() > 0)
                        {
                            foreach (var sc in c.SubAuditCategories)
                            {
                                subCategories.Add(sc);
                            }
                        }
                    }

                    if (subCategories.Count() > 0)
                    {
                        categories.AddRange(subCategories);
                    }

                    var questionResults = new List<AuditQuestionsApiReturnModel>();

                    foreach (var category in categories)
                    {
                        AuditQuestionsApiInputModel auditQuestionsApiInputModel = new AuditQuestionsApiInputModel();

                        auditQuestionsApiInputModel.AuditCategoryId = category.AuditCategoryId;

                        try
                        {
                            var questions = GetAuditQuestions(auditQuestionsApiInputModel, loggedInContext, validationMessages);

                            List<QuestionsForExport> questionsList = new List<QuestionsForExport>();

                            foreach (var question in questions)
                            {
                                AuditQuestionsApiInputModel auditQuestionsApiInputModelDetails = new AuditQuestionsApiInputModel();
                                auditQuestionsApiInputModelDetails.QuestionId = question.QuestionId;

                                try
                                {

                                    var questionsDetails = GetAuditQuestions(auditQuestionsApiInputModelDetails, loggedInContext, validationMessages).FirstOrDefault();
                                    questionResults.Add(questionsDetails);
                                }
                                catch
                                {
                                    var StaticValidation = new ValidationMessage
                                    {
                                        ValidationMessaage = string.Format(ValidationMessages.ExceptionGetAuditCategories, question.QuestionId),
                                        ValidationMessageType = MessageTypeEnum.Error
                                    };
                                    validationMessages.Add(StaticValidation);
                                    validations.Clear();
                                }
                            }

                        }
                        catch
                        {
                            var staticValidation = new ValidationMessage
                            {
                                ValidationMessaage = string.Format(ValidationMessages.ExceptionGetAuditCategories, category.AuditCategoryId),
                                ValidationMessageType = MessageTypeEnum.Error
                            };
                            validationMessages.Add(staticValidation);
                            validations.Clear();
                        }
                    }

                    AuditConductApiInputModel conductModel = new AuditConductApiInputModel();
                    conductModel.AuditId = auditSearchResults.AuditId;
                    conductModel.AuditConductName = conductName;
                    var deadline = (auditÇonductRecords.Skip(skipCount).Select(x => x.DeadLineDate).FirstOrDefault());
                    conductModel.DeadlineDate = Convert.ToDateTime(deadline);
                    conductModel.IsCompleted = false;
                    conductModel.IsIncludeAllQuestions = false;
                    conductModel.ResponsibleUserId = loggedInContext.LoggedInUserId;
                    var selectedQuestions = new List<SelectedQuestionModel>();
                    foreach (var conduct in auditÇonductRecords.Skip(skipCount))
                    {
                        var auditCategoryDataId = categories.Where(x => x.AuditCategoryName.Trim().ToLower() == conduct.Category.Trim().ToLower()).Select(y => y.AuditCategoryId).FirstOrDefault();
                        var questionDataId = questionResults.Where(x => x.QuestionName.Trim().ToLower() == conduct.Name.Trim().ToLower()).Select(y => y.QuestionId).FirstOrDefault();
                        if (questionDataId != null && auditCategoryDataId != null)
                            selectedQuestions.Add(new SelectedQuestionModel()
                            {
                                QuestionId = questionDataId,
                                AuditCategoryId = auditCategoryDataId
                            });
                    }
                    conductModel.SelectedQuestions = new List<SelectedQuestionModel>();
                    conductModel.SelectedQuestions.AddRange(selectedQuestions);
                    var auditConductId = UpsertAuditConduct(conductModel, loggedInContext, validations);

                    if (validations.Count > 0 || auditConductId == Guid.Empty || auditConductId == null)
                    {
                        validationMessages.AddRange(validations);
                        return false;
                    }
                    AuditCategoryApiInputModel auditConductCategoryApiReturnModel = new AuditCategoryApiInputModel();
                    auditConductCategoryApiReturnModel.AuditId = auditSearchResults.AuditId;
                    auditConductCategoryApiReturnModel.ConductId = auditConductId;
                    var conductCategories = SearchAuditCategories(auditConductCategoryApiReturnModel, loggedInContext, validations);
                    var subConductCategories = new List<AuditCategoryApiReturnModel>();
                    foreach (var c in conductCategories)
                    {
                        if (c.SubAuditCategories.Count() > 0)
                        {
                            foreach (var sc in c.SubAuditCategories)
                            {
                                subConductCategories.Add(sc);
                            }
                        }
                    }

                    if (subConductCategories.Count() > 0)
                    {
                        conductCategories.AddRange(subConductCategories);
                    }

                    foreach (var conductCategory in conductCategories)
                    {
                        AuditQuestionsApiInputModel auditConductQuestionsApiInputModel = new AuditQuestionsApiInputModel();

                        auditConductQuestionsApiInputModel.AuditCategoryId = conductCategory.AuditCategoryId;
                        auditConductQuestionsApiInputModel.ConductId = auditConductId;
                        var auditCoductQuestionDetails = SearchAuditConductQuestions(auditConductQuestionsApiInputModel, loggedInContext, validations);

                        foreach (var conductQuestion in auditCoductQuestionDetails)
                        {
                            SubmitAuditConductApiInputModel submitAuditConductApiInputModel = new SubmitAuditConductApiInputModel();
                            var options = JsonConvert.DeserializeObject<List<AuditConductQuestionOptionsModel>>(conductQuestion?.QuestionsXml);


                            if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.TextQuestionTypeId.ToLower())
                            {
                                var answer = auditÇonductRecords.Skip(skipCount)
                                                        .Where(x => x.Category.Trim().ToLower() == conductQuestion.AuditCategoryName.Trim().ToLower() && x.Name.Trim().ToLower() == conductQuestion.QuestionName.Trim().ToLower()).Select(x => x.Answer).FirstOrDefault();
                                if (!string.IsNullOrEmpty(answer) && !string.IsNullOrWhiteSpace(answer))
                                {
                                    submitAuditConductApiInputModel.QuestionOptionText = answer;
                                    submitAuditConductApiInputModel.AuditConductAnswerId = options.Select(x => x.AuditConductAnswerId).FirstOrDefault();
                                }
                                else continue;
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.BooleanQuestionTypeId.ToLower() || conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.DropdownQuestionTypeId.ToLower())
                            {
                                var answer = auditÇonductRecords.Skip(skipCount)
                                                        .Where(x => x.Category.Trim().ToLower() == conductQuestion.AuditCategoryName.Trim().ToLower() && x.Name.Trim().ToLower() == conductQuestion.QuestionName.Trim().ToLower()).Select(x => x.Answer).FirstOrDefault();
                                if (!string.IsNullOrEmpty(answer) && !string.IsNullOrWhiteSpace(answer))
                                {
                                    submitAuditConductApiInputModel.AuditConductAnswerId = options.Where(x => x.QuestionTypeOptionName == answer).Select(x => x.AuditConductAnswerId).FirstOrDefault();
                                }
                                else continue;
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.DateQuestionTypeId.ToLower())
                            {
                                var date = auditÇonductRecords.Skip(skipCount)
                                                        .Where(x => x.Category.Trim().ToLower() == conductQuestion.AuditCategoryName.Trim().ToLower() && x.Name.Trim().ToLower() == conductQuestion.QuestionName.Trim().ToLower()).Select(x => x.Answer).FirstOrDefault();
                                if (!string.IsNullOrEmpty(date) && !string.IsNullOrWhiteSpace(date))
                                {
                                    submitAuditConductApiInputModel.QuestionOptionDate = Convert.ToDateTime(date);
                                    submitAuditConductApiInputModel.AuditConductAnswerId = options.Select(x => x.AuditConductAnswerId).FirstOrDefault();
                                }
                                else continue;
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.NumericQuestionTypeId.ToLower())
                            {
                                var answer = float.Parse(auditÇonductRecords.Skip(skipCount)
                                                        .Where(x => x.Category.Trim().ToLower() == conductQuestion.AuditCategoryName.Trim().ToLower() && x.Name.Trim().ToLower() == conductQuestion.QuestionName.Trim().ToLower()).Select(x => x.Answer).FirstOrDefault());
                                if (!string.IsNullOrEmpty(answer.ToString()) && !string.IsNullOrWhiteSpace(answer.ToString()))
                                {
                                    submitAuditConductApiInputModel.QuestionOptionNumeric = answer;
                                    submitAuditConductApiInputModel.AuditConductAnswerId = options.Select(x => x.AuditConductAnswerId).FirstOrDefault();
                                }
                                else continue;
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.TimeQuestionTypeId.ToLower())
                            {
                                var date = auditÇonductRecords.Skip(skipCount)
                                                       .Where(x => x.Category.Trim().ToLower() == conductQuestion.AuditCategoryName.Trim().ToLower() && x.Name.Trim().ToLower() == conductQuestion.QuestionName.Trim().ToLower()).Select(x => x.Answer).FirstOrDefault();
                                if (!string.IsNullOrEmpty(date) && !string.IsNullOrWhiteSpace(date))
                                {
                                    submitAuditConductApiInputModel.QuestionOptionTime = Convert.ToDateTime(date);
                                    submitAuditConductApiInputModel.AuditConductAnswerId = options.Select(x => x.AuditConductAnswerId).FirstOrDefault();
                                }
                                else continue;
                            }

                            var conductSubmittedAnswerId = SubmitAuditConductQuestion(submitAuditConductApiInputModel, loggedInContext, validations);
                        }



                        //int index = 0;
                        //int count = auditCoductQuestionDetails.Count;
                        //foreach (var conduct in auditÇonductRecords.Skip(skipCount))
                        //{
                        //    SubmitAuditConductApiInputModel submitAuditConductApiInputModel = new SubmitAuditConductApiInputModel();
                        //    //submitAuditConductApiInputModel.AuditConductAnswerId = auditCoductQuestionDetails.Skip(skipCount).SkipWhile((x, i) => )
                        //    var conductDetails = auditCoductQuestionDetails.Where(x => x.ConductName == conductName && x.AuditCategoryName == conduct.AuditConductName)
                        //}

                    }

                    if (subConductCategories.Count() > 0)
                    {
                        conductCategories.AddRange(subConductCategories);
                    }

                    fileReader.Close();

                    return true;
                });
                return true;
            }
        }

        public List<object> ProcessExcelData(Guid? projectId, Stream fileStream, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Process Excel Data", "Process Excel Data"));

            var excelResult = new List<UploadAuditsFromExcel>();
            try
            {
                var Audits = new List<UploadAuditsFromExcel>();

                using (var excelPackage = new OfficeOpenXml.ExcelPackage(fileStream))
                {
                    //var worksheet = excelPackage.Workbook.Worksheets[1];

                    foreach (var worksheet in excelPackage.Workbook.Worksheets)
                    {
                        int rowsCount = worksheet.Dimension.End.Row;

                        string Audit = string.Empty;
                        string CatName = string.Empty;
                        string QName = string.Empty;

                        for (int i = 2; i <= rowsCount; i++)
                        {
                            Audit = string.IsNullOrEmpty(worksheet.Cells[i, 13]?.Text) ? Audit : worksheet.Cells[i, 13]?.Text;
                            CatName = string.IsNullOrEmpty(worksheet.Cells[i, 2]?.Text) ? CatName : worksheet.Cells[i, 2]?.Text;
                            QName = string.IsNullOrEmpty(worksheet.Cells[i, 6]?.Text) ? QName : worksheet.Cells[i, 6]?.Text;

                            if (!string.IsNullOrEmpty(worksheet.Cells[i, 10]?.Text) || !string.IsNullOrEmpty(worksheet.Cells[i, 2]?.Text))
                            {
                                //if(string.IsNullOrEmpty(worksheet.Cells[i, 13]?.Text))
                                //{
                                    if (string.IsNullOrEmpty(worksheet.Cells[i, 2]?.Text))
                                    {
                                        // belongs to second question
                                        if (!string.IsNullOrEmpty(worksheet.Cells[i, 6]?.Text))
                                        {
                                            // new question
                                            //var cat = Audits.Where(x => x.AuditName == Audit).Select(y => y.CategoryForExport).Where(z => (z.Select(a => a.CategoryName == CatName).FirstOrDefault()));
                                            var cats = Audits.Where(x => x.AuditName == Audit).Select(y => y.CategoryForExport).ToList().Where(z => z.Select(a => a.CategoryName == CatName).FirstOrDefault()).FirstOrDefault().Select(r => r.Questions).FirstOrDefault();

                                            var cat = new QuestionsForExport()
                                            {
                                                Type = worksheet.Cells[i, 5]?.Text ?? string.Empty,
                                                Name = worksheet.Cells[i, 6]?.Text ?? string.Empty,
                                                Score = string.IsNullOrEmpty(worksheet.Cells[i, 7]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 7]?.Text),
                                                QuestionDescription = worksheet.Cells[i, 12]?.Text ?? string.Empty,
                                                QuestionOptions = new List<QuestionOptionsForExport>()
                                                    {
                                                            new QuestionOptionsForExport()
                                                            {
                                                                OptionName = worksheet.Cells[i, 8]?.Text ?? string.Empty,
                                                                Order = string.IsNullOrEmpty(worksheet.Cells[i, 9]?.Text) ? 0 : int.Parse(worksheet.Cells[i, 9]?.Text),
                                                                OptionScore = string.IsNullOrEmpty(worksheet.Cells[i, 10]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 10]?.Text),
                                                                Result = string.IsNullOrEmpty(worksheet.Cells[i, 11]?.Text) ? false : Convert.ToBoolean(worksheet.Cells[i, 11]?.Text)
                                                            }
                                                    }
                                            };
                                            cats.Add(cat);
                                        //Audits.Where(x => x.AuditName == Audit).Select(y => y.CategoryForExport).FirstOrDefault().Where(z => z.CategoryName == CatName).ToList().ForEach(r => r.Questions = cats);
                                        Audits.Where(x => x.AuditName == Audit && x.CategoryForExport[0].CategoryName == CatName).FirstOrDefault().CategoryForExport.ForEach(a => a.Questions = cats);
                                        }
                                        else
                                        {
                                            //Options
                                            var an = Audits.Where(x => x.AuditName == Audit && x.CategoryForExport[0].CategoryName == CatName).ToList().Select(r => r.CategoryForExport).FirstOrDefault().Select(a => a.Questions).FirstOrDefault();
                                            //var bn = an.Where(z => z.CategoryName == CatName).Select(r => r.Questions).FirstOrDefault();
                                            var qOts = an.Where(a => a.Name == QName).Select(c => c.QuestionOptions).FirstOrDefault();

                                            var qOt = new QuestionOptionsForExport()
                                            {
                                                OptionName = worksheet.Cells[i, 8]?.Text ?? string.Empty,
                                                Order = string.IsNullOrEmpty(worksheet.Cells[i, 9]?.Text) ? 0 : int.Parse(worksheet.Cells[i, 9]?.Text),
                                                OptionScore = string.IsNullOrEmpty(worksheet.Cells[i, 10]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 10]?.Text),
                                                Result = string.IsNullOrEmpty(worksheet.Cells[i, 11]?.Text) ? false : Convert.ToBoolean(worksheet.Cells[i, 11]?.Text)
                                            };
                                            qOts.Add(qOt);
                                            //Audits.Where(x => x.AuditName == Audit).Select(y => y.CategoryForExport).FirstOrDefault().Where(z => z.CategoryName == CatName).ToList().Select(r => r.Questions).FirstOrDefault().Where(a => a.Name == QName).ToList().ForEach(r => r.QuestionOptions = qOts);
                                            Audits.Where(x => x.AuditName == Audit && x.CategoryForExport[0].CategoryName == CatName).ToList().Select(r => r.CategoryForExport).FirstOrDefault().Select(a => a.Questions).FirstOrDefault().Where(a => a.Name == QName).ToList().ForEach(r => r.QuestionOptions = qOts);
                                    }

                                    //}
                                    //else if(string.IsNullOrEmpty(worksheet.Cells[i, 3]?.Text))
                                    //{
                                    //    var row = new CategoryForExport()
                                    //    {
                                    //        CategoryName = worksheet.Cells[i, 2]?.Text ?? string.Empty,
                                    //        ParentCategoryName = worksheet.Cells[i, 3]?.Text ?? string.Empty,
                                    //        Questions = new List<QuestionsForExport>()
                                    //    {
                                    //        new QuestionsForExport()
                                    //        {
                                    //            Type = worksheet.Cells[i, 5]?.Text ?? string.Empty,
                                    //            Name = worksheet.Cells[i, 6]?.Text ?? string.Empty,
                                    //            Score = string.IsNullOrEmpty(worksheet.Cells[i, 7]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 7]?.Text),
                                    //            QuestionDescription = worksheet.Cells[i, 12]?.Text ?? string.Empty,
                                    //            QuestionOptions = new List<QuestionOptionsForExport>()
                                    //            {
                                    //                new QuestionOptionsForExport()
                                    //                {
                                    //                    OptionName = worksheet.Cells[i, 8]?.Text ?? string.Empty,
                                    //                    Order = string.IsNullOrEmpty(worksheet.Cells[i, 9]?.Text) ? 0 : int.Parse(worksheet.Cells[i, 9]?.Text),
                                    //                    OptionScore = string.IsNullOrEmpty(worksheet.Cells[i, 10]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 10]?.Text),
                                    //                    Result = string.IsNullOrEmpty(worksheet.Cells[i, 11]?.Text) ? false : Convert.ToBoolean(worksheet.Cells[i, 11]?.Text)
                                    //                }
                                    //            }
                                    //        }
                                    //    }
                                    //    };
                                    //    var cat = Audits.Where(x => x.AuditName == Audit).FirstOrDefault().CategoryForExport;
                                    //    cat.Add(row);
                                    //    //Audits.Where(x => x.AuditName == Audit).ToList().ForEach(y => y.CategoryForExport = cat);
                                    //} 
                                    //else
                                    //{
                                    //    var row = new CategoryForExport()
                                    //    {
                                    //        CategoryName = worksheet.Cells[i, 2]?.Text ?? string.Empty,
                                    //        ParentCategoryName = worksheet.Cells[i, 3]?.Text ?? string.Empty,
                                    //        Questions = new List<QuestionsForExport>()
                                    //    {
                                    //        new QuestionsForExport()
                                    //        {
                                    //            Type = worksheet.Cells[i, 5]?.Text ?? string.Empty,
                                    //            Name = worksheet.Cells[i, 6]?.Text ?? string.Empty,
                                    //            Score = string.IsNullOrEmpty(worksheet.Cells[i, 7]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 7]?.Text),
                                    //            QuestionDescription = worksheet.Cells[i, 12]?.Text ?? string.Empty,
                                    //            QuestionOptions = new List<QuestionOptionsForExport>()
                                    //            {
                                    //                new QuestionOptionsForExport()
                                    //                {
                                    //                    OptionName = worksheet.Cells[i, 8]?.Text ?? string.Empty,
                                    //                    Order = string.IsNullOrEmpty(worksheet.Cells[i, 9]?.Text) ? 0 : int.Parse(worksheet.Cells[i, 9]?.Text),
                                    //                    OptionScore = string.IsNullOrEmpty(worksheet.Cells[i, 10]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 10]?.Text),
                                    //                    Result = string.IsNullOrEmpty(worksheet.Cells[i, 11]?.Text) ? false : Convert.ToBoolean(worksheet.Cells[i, 11]?.Text)
                                    //                }
                                    //            }
                                    //        }
                                    //    }
                                    //    };
                                    //    var an = Audits.Where(x => x.AuditName == Audit).Select(y => y.CategoryForExport).FirstOrDefault().Where(z => z.CategoryName == worksheet.Cells[i, 3]?.Text).ToList().FirstOrDefault();
                                    //    //an.SubCategoriesForExport == null ? an.SubCategoriesForExport = new List<CategoryForExport>() { row } : an.SubCategoriesForExport.Add(row);
                                    //    if (an.SubCategoriesForExport == null)
                                    //    {
                                    //        an.SubCategoriesForExport = new List<CategoryForExport>() { row };
                                    //    } 
                                    //    else
                                    //    {
                                    //        an.SubCategoriesForExport.Add(row);
                                    //    }
                                    //    Audits.Where(x => x.AuditName == Audit).Select(y => y.CategoryForExport).FirstOrDefault().Where(z => z.CategoryName == worksheet.Cells[i, 3]?.Text).ToList().ForEach(z => z.SubCategoriesForExport = an.SubCategoriesForExport);
                                    //}
                                }
                             else
                                {
                                    var row = new UploadAuditsFromExcel()
                                    {
                                        SNo = worksheet.Cells[i, 1]?.Text ?? string.Empty,
                                        AuditName = string.IsNullOrEmpty(worksheet.Cells[i, 13]?.Text) ? Audit : worksheet.Cells[i, 13]?.Text,
                                        CategoryPath = worksheet.Cells[i, 4]?.Text ?? string.Empty,
                                        CategoryForExport = new List<CategoryForExport>()
                                    {
                                    new CategoryForExport()
                                    {
                                        CategoryName = worksheet.Cells[i, 2]?.Text ?? string.Empty,
                                        ParentCategoryName = worksheet.Cells[i, 3]?.Text ?? string.Empty,
                                        Questions = new List<QuestionsForExport>()
                                        {
                                            new QuestionsForExport()
                                            {
                                                Type = worksheet.Cells[i, 5]?.Text ?? string.Empty,
                                                Name = worksheet.Cells[i, 6]?.Text ?? string.Empty,
                                                Score = string.IsNullOrEmpty(worksheet.Cells[i, 7]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 7]?.Text),
                                                QuestionDescription = worksheet.Cells[i, 12]?.Text ?? string.Empty,
                                                QuestionOptions = new List<QuestionOptionsForExport>()
                                                {
                                                    new QuestionOptionsForExport()
                                                    {
                                                        OptionName = worksheet.Cells[i, 8]?.Text ?? string.Empty,
                                                        Order = string.IsNullOrEmpty(worksheet.Cells[i, 9]?.Text) ? 0 : int.Parse(worksheet.Cells[i, 9]?.Text),
                                                        OptionScore = string.IsNullOrEmpty(worksheet.Cells[i, 10]?.Text) ? 0 : float.Parse(worksheet.Cells[i, 10]?.Text),
                                                        Result = string.IsNullOrEmpty(worksheet.Cells[i, 11]?.Text) ? false : Convert.ToBoolean(worksheet.Cells[i, 11]?.Text)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    }
                                    };
                                    Audits.Add(row);
                                }
                            }
                            
                            }
                        //Audits.Where(x => x.AuditName == Audit).Select(y => y.CategoryForExport).FirstOrDefault()
                        //    .Select(z => z.SubCategoriesForExport = { })

                    }

                    //foreach(var audit in Audits)
                    //{
                    //    var validations = new List<ValidationMessage>();
                    //    AuditComplianceApiInputModel auditComplianceApiInputModel = new AuditComplianceApiInputModel()
                    //    {
                    //        AuditName = audit.AuditName,
                    //        ResponsibleUserId = loggedInContext.LoggedInUserId,
                    //        ProjectId = projectId
                    //    };

                    //    var auditId = UpsertAuditCompliance(auditComplianceApiInputModel, loggedInContext, validations);
                    Task.Factory.StartNew(() =>
                    {
                        QuestionTypeApiInputModel questionTypeApiInputModel = new QuestionTypeApiInputModel()
                        {
                            IsArchived = false
                        };

                        List<QuestionTypeApiReturnModel> masterQuestionTypes = GetMasterQuestionTypes(questionTypeApiInputModel, loggedInContext, validationMessages);

                        List<QuestionTypeApiReturnModel> questionTypes = GetQuestionTypes(questionTypeApiInputModel, loggedInContext, validationMessages);

                        questionTypes.AddRange(masterQuestionTypes);


                        //}
                        var NewAudits = new List<UploadAuditsFromExcel>();
                        NewAudits = Audits.ToList();
                        //foreach (var audit in Enumerable.Reverse(NewAudits).ToList())
                        //{
                        //    var PCat = audit.CategoryForExport.Select(x => x.ParentCategoryName).FirstOrDefault();
                        //    if (PCat != null && PCat != "")
                        //    {
                        //        var Cat = NewAudits.Where(x => x.AuditName == audit.AuditName).Select(y => y.CategoryForExport)
                        //             .FirstOrDefault().Where(z => z.CategoryName == PCat.ToString()).FirstOrDefault();
                        //        //(Cat.SubCategoriesForExport==null) ? (Cat.SubCategoriesForExport = new List<CategoryForExport>() { audit.CategoryForExport[0] }) : Cat.SubCategoriesForExport.Add(audit.CategoryForExport[0]);
                        //        if(Cat.SubCategoriesForExport == null)
                        //        {
                        //            Cat.SubCategoriesForExport = new List<CategoryForExport>() { audit.CategoryForExport[0] };
                        //        } 
                        //        else
                        //        {
                        //            Cat.SubCategoriesForExport.Add(audit.CategoryForExport[0]);
                        //        }
                        //        NewAudits.Where(x => x.AuditName == audit.AuditName).Select(y => y.CategoryForExport)
                        //             .FirstOrDefault().Where(z => z.CategoryName == PCat.ToString()).FirstOrDefault().SubCategoriesForExport = Cat.SubCategoriesForExport;
                        //        NewAudits.Remove(audit);
                        //    }

                        //}

                        //var audits = NewAudits.GroupBy(x => x.AuditName).ToList();

                        //foreach(var audit in audits)
                        //{
                        //    var validations = new List<ValidationMessage>();
                        //    AuditComplianceApiInputModel auditComplianceApiInputModel = new AuditComplianceApiInputModel()
                        //    {
                        //        AuditName = audit.Key,
                        //        ResponsibleUserId = loggedInContext.LoggedInUserId,
                        //        ProjectId = projectId
                        //    };

                        //    var auditId = UpsertAuditCompliance(auditComplianceApiInputModel, loggedInContext, validations);

                        //    foreach (var a in audit)
                        //    {

                        //    }
                        //}
                        Guid? auditId = Guid.Empty;
                        Guid? currentCategoryId = Guid.Empty;
                        var thisAuditName = string.Empty;
                        foreach (var audit in NewAudits)
                        {
                            var oldAuditName = audit.AuditName;
                            bool oldAudit = oldAuditName == thisAuditName;
                            var validations = new List<ValidationMessage>();
                            if (!oldAudit)
                            {
                                thisAuditName = oldAuditName;
                                AuditComplianceApiInputModel auditComplianceApiInputModel = new AuditComplianceApiInputModel()
                                {
                                    AuditName = audit.AuditName,
                                    ResponsibleUserId = loggedInContext.LoggedInUserId,
                                    ProjectId = projectId
                                };

                                auditId = UpsertAuditCompliance(auditComplianceApiInputModel, loggedInContext, validations);
                            }
                            if (audit.CategoryForExport[0].ParentCategoryName == null || audit.CategoryForExport[0].ParentCategoryName == "")
                            {
                                var auditCategoryInputModel = new AuditCategoryApiInputModel()
                                {
                                    AuditId = auditId,
                                    ParentAuditCategoryId = null,
                                    AuditCategoryName = audit.CategoryForExport[0].CategoryName
                                };
                                audit.CategoryForExport[0].CategoryId = UpsertAuditCategory(auditCategoryInputModel, loggedInContext, validations);

                            }
                            else
                            {
                                var PCat = NewAudits.Where(x => x.AuditName == audit.AuditName && x.CategoryForExport[0].CategoryName == audit.CategoryForExport[0].ParentCategoryName).FirstOrDefault().CategoryForExport[0];
                                var auditCategoryInputModel = new AuditCategoryApiInputModel()
                                {
                                    AuditId = auditId,
                                    ParentAuditCategoryId = PCat.CategoryId,
                                    AuditCategoryName = audit.CategoryForExport[0].CategoryName
                                };
                                audit.CategoryForExport[0].CategoryId = UpsertAuditCategory(auditCategoryInputModel, loggedInContext, validations);
                            }
                            foreach (var question in audit.CategoryForExport[0].Questions)
                            {
                                var masterquestionType = false;
                                var type = questionTypes.FirstOrDefault(p => p.QuestionTypeName?.Trim().ToLower() == question.Type?.Trim().ToLower())?.QuestionTypeId;
                                var questionTypeName = questionTypes.FirstOrDefault(p => p.QuestionTypeName?.Trim().ToLower() == question.Type?.Trim().ToLower())?.MasterQuestionTypeName;
                                // var masterQuestionTypeId = questionTypes.FirstOrDefault(p => p.QuestionTypeName?.Trim().ToLower() == questionTypeName?.Trim().ToLower())?.MasterQuestionTypeId;
                                if (string.IsNullOrEmpty(type.ToString()))
                                {
                                    masterquestionType = true;
                                    type = questionTypes.FirstOrDefault(p => p.MasterQuestionTypeName?.Trim().ToLower() == question.Type?.Trim().ToLower())?.MasterQuestionTypeId;
                                    questionTypeName = question.Type;
                                }
                                var optionsModel = new List<QuestionTypeOptionsModel>();
                                foreach (var i in question.QuestionOptions)
                                    if (questionTypeName == "Boolean" || questionTypeName == "Dropdown")
                                    {
                                        optionsModel.Add(new QuestionTypeOptionsModel
                                        {
                                            QuestionTypeOptionOrder = (i.Order),
                                            QuestionTypeOptionScore = (i.OptionScore),
                                            QuestionTypeOptionName = i.OptionName
                                        });
                                    }
                                    else
                                    {
                                        optionsModel.Add(new QuestionTypeOptionsModel
                                        {
                                            QuestionTypeOptionScore = (i.OptionScore)
                                        });
                                    }

                                var QuestionTypeApiInputModel = new QuestionTypeApiInputModel()
                                {
                                    IsArchived = false,
                                    IsFromMasterQuestionType = masterquestionType,
                                    MasterQuestionTypeId = masterquestionType == true ? type : questionTypes.FirstOrDefault(p => p.QuestionTypeName?.Trim().ToLower() == question.Type?.Trim().ToLower())?.MasterQuestionTypeId,
                                    QuestionTypeId = masterquestionType == true ? null : type,
                                    //QuestionTypeName = question.Type,
                                    QuestionTypeOptions = optionsModel
                                };

                                var questionId = UpsertQuestionType(QuestionTypeApiInputModel, loggedInContext, validationMessages);

                                validationMessages.Clear();
                                var questionTypeOptions = GetQuestionTypes(new QuestionTypeApiInputModel
                                {
                                    IsArchived = false,
                                    IsFromMasterQuestionType = masterquestionType,
                                    QuestionTypeId = masterquestionType == true ? questionId : type
                                }, loggedInContext, validationMessages);


                                var questionOptionsModel = new List<AuditQuestionOptions>();
                                if (question.QuestionOptions.Count > 0)
                                {
                                    foreach (var index in questionTypeOptions[0].QuestionTypeOptions)
                                    {
                                        var auditQuestion = new AuditQuestionOptions();
                                        auditQuestion.QuestionOptionOrder = index.QuestionTypeOptionOrder;
                                        auditQuestion.QuestionOptionScore = index.QuestionTypeOptionScore.HasValue ? index.QuestionTypeOptionScore.Value : 0;
                                        auditQuestion.QuestionOptionName = index.QuestionTypeOptionName;
                                        auditQuestion.QuestionTypeOptionId = index.QuestionTypeOptionId;
                                        string result = null;
                                        var typeOfQuestion = question.Type;
                                        if (questionTypeName == "Date" || questionTypeName == "Numeric" || questionTypeName == "Text" || questionTypeName == "Time")
                                        {
                                            result = "true";
                                        }
                                        else
                                        {
                                            result = question.QuestionOptions.Find(p => (p?.Order) == index?.QuestionTypeOptionOrder)?.Result.ToString();
                                        }
                                        auditQuestion.QuestionOptionResult = string.IsNullOrWhiteSpace(result) || result.Trim()?.ToLower() == "false" ? false : true;
                                        questionOptionsModel.Add(auditQuestion);
                                    }
                                }

                                //string.IsNullOrWhiteSpace(p.Result) || p.Result == "false" ? false : true,

                                var questionsApiInputModel = new AuditQuestionsApiInputModel()
                                {

                                    AuditCategoryId = audit.CategoryForExport[0].CategoryId,
                                    AuditId = auditId,
                                    //IsOriginalQuestionTypeScore = string.IsNullOrWhiteSpace(question.UseOriginalScrore) || question.UseOriginalScrore.Trim()?.ToLower() == "false" ? false : true,
                                    //IsQuestionMandatory = string.IsNullOrWhiteSpace(question.IsMandatory) || question.IsMandatory.Trim()?.ToLower() == "false" ? false : true,
                                    QuestionTypeId = masterquestionType == true ? questionId : type,
                                    QuestionOptions = questionOptionsModel,
                                    QuestionName = question.Name,
                                    QuestionDescription = question.QuestionDescription
                                };

                                var Id = UpsertAuditQuestion(questionsApiInputModel, loggedInContext, validationMessages);
                            }

                        }
                    });

                }
                return null;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadAuditsFromExcel", "ComplianceAuditService ", exception.Message), exception);
                return null;
            }
        }

        public bool UploadAuditsFromCsv(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {

                var httpRequest = HttpContext.Current.Request;

                var loaded = UploadAuditFromCsv(projectId, httpRequest, loggedInContext, validationMessages);
                return loaded;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadAuditsFromCsv", "ComplianceAuditService ", exception.Message), exception);

                throw;
            }

        }

        public bool UploadAuditFromCsv(Guid? projectId, HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (TextReader fileReader = new StreamReader(httpRequest.InputStream))
            {
                fileReader.ReadLine(); //to skip the first line

                var csvReader = new CsvReader(fileReader);

                csvReader.Configuration.MissingFieldFound = null;

                csvReader.Configuration.BadDataFound = null;

                csvReader.Configuration.HasHeaderRecord = false;

                List<AuditCsvExtractModelcs> auditRecords = csvReader.GetRecords<AuditCsvExtractModelcs>().ToList();

                var skipCount = auditRecords.FindIndex(x => x.AuditName.Contains("AuditName"));

                List<ValidationMessage> validations = new List<ValidationMessage>();

                if (skipCount != -1)
                {
                    skipCount = skipCount + 1;
                }
                else
                {
                    var staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format("Invalid file format. Choose correct file."),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    //throw new Exception("Invalid Csv file");
                    return false;
                }

                var auditName = auditRecords.Skip(skipCount).FirstOrDefault()?.AuditName;
                if (string.IsNullOrEmpty(auditName))
                {
                    var staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format("Audit name should not be empty."),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    return false;
                }

                AuditComplianceApiInputModel auditComplianceApiInputModel = new AuditComplianceApiInputModel()
                {
                    AuditName = auditName,
                    ResponsibleUserId = loggedInContext.LoggedInUserId,
                    ProjectId = projectId
                };

                var auditId = UpsertAuditCompliance(auditComplianceApiInputModel, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadAuditFromCsv", "Audit", "Unable to upsert audit with the name " + auditName + " trying to update if available"));
                    validationMessages.AddRange(validations);
                    var staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format(ValidationMessages.ExceptionInsertAudit, auditName),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    return false;
                }
                else if (auditId == null || auditId == Guid.Empty)
                {
                    var staticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format("No audit found with the name {0}.", auditName),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(staticValidation);
                    return false;
                }

                Task.Factory.StartNew(() =>
                {

                    QuestionTypeApiInputModel questionTypeApiInputModel = new QuestionTypeApiInputModel()
                    {
                        IsArchived = false
                    };

                    List<QuestionTypeApiReturnModel> masterQuestionTypes = GetMasterQuestionTypes(questionTypeApiInputModel, loggedInContext, validationMessages);

                    List<QuestionTypeApiReturnModel> questionTypes = GetQuestionTypes(questionTypeApiInputModel, loggedInContext, validationMessages);

                    questionTypes.AddRange(masterQuestionTypes);

                    var finalRecords = auditRecords.Skip(skipCount).ToList();

                    List<SavedCategoriesModel> availableSections = new List<SavedCategoriesModel>();

                    for (int rowIndex = 0; rowIndex < finalRecords.Count; rowIndex++)
                    {
                        var audit = finalRecords[rowIndex];

                        if (string.IsNullOrEmpty(audit.AuditName) && string.IsNullOrEmpty(audit.Type) && (string.IsNullOrEmpty(audit.Order) || string.IsNullOrEmpty(audit.Score)))
                        {
                            break;
                        }

                        if (string.IsNullOrEmpty(audit.AuditName) && string.IsNullOrEmpty(audit.Type) && !string.IsNullOrEmpty(audit.Order) && !string.IsNullOrEmpty(audit.Option) && ((audit.Type == "Dropdown") || (audit.Type == "Boolean")) && !string.IsNullOrEmpty(audit.Score))
                        {
                            continue;
                        }
                        else if (string.IsNullOrEmpty(audit.AuditName) && string.IsNullOrEmpty(audit.Type) && !string.IsNullOrEmpty(audit.Score))
                        {
                            continue;
                        }

                        var sectionId = SaveCategoriesFromCsv(audit.CategoryHierarchy, auditId, audit.CategoryDescription, availableSections, loggedInContext, validations);

                        if (sectionId == null && validations.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadAuditFromCsv", "Audit", "Didnot found any audit with the name " + auditName + " for updation"));
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            continue;
                        }
                        validations.Clear();
                        var audits = new List<AuditCsvExtractModelcs>();
                        audits.Add(finalRecords[rowIndex]);

                        for (int inRowIndex = rowIndex; rowIndex < finalRecords.Count; inRowIndex++)
                        {
                            if (string.IsNullOrEmpty(finalRecords[inRowIndex + 1].Type) && !string.IsNullOrEmpty(finalRecords[inRowIndex + 1].Order) && !string.IsNullOrEmpty(finalRecords[inRowIndex + 1].Option)
                            && ((finalRecords[inRowIndex + 1].Type == "Dropdown") || (finalRecords[inRowIndex + 1].Type == "Boolean")))
                            {
                                audits.Add(finalRecords[inRowIndex + 1]);
                            }
                            else if (string.IsNullOrEmpty(finalRecords[inRowIndex + 1].Type) && !string.IsNullOrEmpty(finalRecords[inRowIndex + 1].Score))
                            {
                                audits.Add(finalRecords[inRowIndex + 1]);
                            }
                            else
                            {
                                break;
                            }
                        }
                        var testCaseId = SaveQuestionsFromCsv(audits, sectionId, auditId, loggedInContext, validations, questionTypes);


                        if (validations.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadAuditFromCsv", "Audit", "Didnot found any audit with the name " + auditName + " for updation"));
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            continue;
                        }
                    }

                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                    }

                    fileReader.Close();

                    return true;
                });

                return true;
            }

        }

        public Guid? SaveCategoriesFromCsv(string categoryHierarchy, Guid? auditId, string categoryDescription, List<SavedCategoriesModel> availableSections, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var sectionTree = categoryHierarchy.Split('>').ToList();

                Guid? parentSectionId = availableSections.FirstOrDefault(p => p.CategoryName == sectionTree[(sectionTree.Count - 1)] && p.Level == (sectionTree.Count - 1))?.CategoryId;

                if (parentSectionId != null)
                {
                    return parentSectionId;
                }

                for (var level = 0; level < sectionTree.Count; level++)
                {
                    var currentSectionId = availableSections.FirstOrDefault(p => p.CategoryName == sectionTree[level]?.Trim())?.CategoryId;

                    if (currentSectionId == null)
                    {
                        List<ValidationMessage> validations = new List<ValidationMessage>();

                        var auditCategoryInputModel = new AuditCategoryApiInputModel()
                        {
                            AuditId = auditId,
                            ParentAuditCategoryId = parentSectionId,
                            AuditCategoryName = sectionTree[level]?.Trim(),
                            AuditCategoryDescription = level == sectionTree.Count - 1 ? categoryDescription : ""
                        };

                        currentSectionId = UpsertAuditCategory(auditCategoryInputModel, loggedInContext, validations);

                        availableSections.Add(new SavedCategoriesModel
                        {
                            ParentName = level > 0 ? sectionTree[level - 1]?.Trim() : null,
                            CategoryId = currentSectionId,
                            CategoryName = sectionTree[level]?.Trim(),
                            Level = level
                        });
                    }

                    parentSectionId = currentSectionId;
                }

                return parentSectionId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveCategoriesFromCsv", "ComplianceAuditService ", exception.Message), exception);

                var staticValidation = new ValidationMessage
                {
                    ValidationMessaage = string.Format(exception.Message),
                    ValidationMessageType = MessageTypeEnum.Error
                };
                validationMessages.Add(staticValidation);
                return null;
            }

        }

        private Guid? SaveQuestionsFromCsv(List<AuditCsvExtractModelcs> rows, Guid? sectionId, Guid? auditId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, List<QuestionTypeApiReturnModel> questionTypes)
        {
            try
            {
                var question = rows[0];
                var masterquestionType = false;
                var type = questionTypes.FirstOrDefault(p => p.QuestionTypeName?.Trim().ToLower() == question.Type?.Trim().ToLower())?.QuestionTypeId;
                var questionTypeName = questionTypes.FirstOrDefault(p => p.QuestionTypeName?.Trim().ToLower() == question.Type?.Trim().ToLower())?.MasterQuestionTypeName;
                // var masterQuestionTypeId = questionTypes.FirstOrDefault(p => p.QuestionTypeName?.Trim().ToLower() == questionTypeName?.Trim().ToLower())?.MasterQuestionTypeId;
                if (string.IsNullOrEmpty(type.ToString()))
                {
                    masterquestionType = true;
                    type = questionTypes.FirstOrDefault(p => p.MasterQuestionTypeName?.Trim().ToLower() == question.Type?.Trim().ToLower())?.MasterQuestionTypeId;
                    questionTypeName = question.Type;
                }


                var optionsModel = new List<QuestionTypeOptionsModel>();
                if (rows.Count > 0)
                {
                    rows.ForEach(p => p.Type = rows[0].Type);
                    foreach (var index in rows)
                    {
                        if (questionTypeName == "Boolean" || questionTypeName == "Dropdown")
                        {
                            optionsModel.Add(new QuestionTypeOptionsModel
                            {
                                QuestionTypeOptionOrder = GetStepOrder(index.Order),
                                QuestionTypeOptionScore = float.Parse(index.Score),
                                QuestionTypeOptionName = index.Option
                            });
                        }
                        else
                        {
                            optionsModel.Add(new QuestionTypeOptionsModel
                            {
                                QuestionTypeOptionScore = float.Parse(index.Score)
                            });
                        }
                    }
                }

                var questionTypeApiInputModel = new QuestionTypeApiInputModel()
                {
                    IsArchived = false,
                    IsFromMasterQuestionType = masterquestionType,
                    MasterQuestionTypeId = masterquestionType == true ? type : questionTypes.FirstOrDefault(p => p.QuestionTypeName?.Trim().ToLower() == question.Type?.Trim().ToLower())?.MasterQuestionTypeId,
                    QuestionTypeId = masterquestionType == true ? null : type,
                    //QuestionTypeName = question.Type,
                    QuestionTypeOptions = optionsModel
                };

                var questionId = UpsertQuestionType(questionTypeApiInputModel, loggedInContext, validationMessages);

                validationMessages.Clear();
                var questionTypeOptions = GetQuestionTypes(new QuestionTypeApiInputModel
                {
                    IsArchived = false,
                    IsFromMasterQuestionType = masterquestionType,
                    QuestionTypeId = masterquestionType == true ? questionId : type
                }, loggedInContext, validationMessages);


                var questionOptionsModel = new List<AuditQuestionOptions>();
                if (rows.Count > 0)
                {
                    foreach (var index in questionTypeOptions[0].QuestionTypeOptions)
                    {
                        var auditQuestion = new AuditQuestionOptions();
                        auditQuestion.QuestionOptionOrder = index.QuestionTypeOptionOrder;
                        auditQuestion.QuestionOptionScore = index.QuestionTypeOptionScore.HasValue ? index.QuestionTypeOptionScore.Value : 0;
                        auditQuestion.QuestionOptionName = index.QuestionTypeOptionName;
                        auditQuestion.QuestionTypeOptionId = index.QuestionTypeOptionId;
                        string result = null;
                        var typeOfQuestion = rows[0].Type;
                        if (questionTypeName == "Date" || questionTypeName == "Numeric" || questionTypeName == "Text" || questionTypeName == "Time")
                        {
                            result = "true";
                        }
                        else
                        {
                            result = rows.Find(p => GetStepOrder(p?.Order) == index?.QuestionTypeOptionOrder)?.Result;
                        }
                        auditQuestion.QuestionOptionResult = string.IsNullOrWhiteSpace(result) || result.Trim()?.ToLower() == "false" ? false : true;
                        questionOptionsModel.Add(auditQuestion);
                    }
                }

                //string.IsNullOrWhiteSpace(p.Result) || p.Result == "false" ? false : true,

                var questionsApiInputModel = new AuditQuestionsApiInputModel()
                {

                    AuditCategoryId = sectionId,
                    AuditId = auditId,
                    IsOriginalQuestionTypeScore = string.IsNullOrWhiteSpace(question.UseOriginalScrore) || question.UseOriginalScrore.Trim()?.ToLower() == "false" ? false : true,
                    IsQuestionMandatory = string.IsNullOrWhiteSpace(question.IsMandatory) || question.IsMandatory.Trim()?.ToLower() == "false" ? false : true,
                    QuestionTypeId = masterquestionType == true ? questionId : type,
                    QuestionOptions = questionOptionsModel,
                    QuestionName = question.Name,
                    QuestionDescription = rows[0].QuestionDescription
                    //Title = testCase.Title,
                    //SectionId = sectionId,
                    //TemplateId = teplateId,
                    //TypeId = testCaseTypeId,
                    //Estimate = estimate,
                    //References = testCase.References,
                    //Steps = testCase.Template?.Trim()?.ToLower() == "test case (text)" ? testCase.StepDescription : null,
                    //ExpectedResult = testCase.Template?.Trim()?.ToLower() == "test case (text)" ? testCase.StepsExpectedResult : null,
                    //IsArchived = false,
                    //Mission = testCase.Template?.Trim()?.ToLower() == "exploratory session" ? testCase.Mission : null,
                    //Goals = testCase.Template?.Trim() == "exploratory session" ? testCase.Goals : null,
                    //PriorityId = priorityId,
                    //AutomationTypeId = automationId,
                    //TestSuiteId = testSuiteId,
                    //Precondition = preCondition,
                    //TestCaseSteps = testCase.Template?.Trim()?.ToLower() == "test case (steps)" ? testCaseSteps : null
                };

                return UpsertAuditQuestion(questionsApiInputModel, loggedInContext, validationMessages);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveQuestionsFromCsv", "ComplianceAuditService ", exception.Message), exception);

                var staticValidation = new ValidationMessage
                {
                    ValidationMessaage = string.Format(exception.Message),
                    ValidationMessageType = MessageTypeEnum.Error
                };
                validationMessages.Add(staticValidation);
                return null;
            }

        }


        private List<AuditCategoryApiReturnModel> GetSubCategories(List<AuditCategoryApiReturnModel> subcategories, List<AuditCategoryApiReturnModel> cats, int index, List<AuditCategoryApiReturnModel> scats)
        {
            AuditCategoryApiReturnModel category = new AuditCategoryApiReturnModel();
            //categories.Add(cats[index]);
            //if(cats[index].SubAuditCategories != null && cats[index].SubAuditCategories.Count() > 0)
            //{
            //    for (var i = 0; i < cats[index].SubAuditCategories.Count(); i++)
            //    {
            //        GetSubCategories(cats[index].SubAuditCategories[i], cats[index].SubAuditCategories, i);
            //    }
            //}
            //return categories;
            if(subcategories != null && subcategories.Count() > 0)
            {
                for(var i = 0; i < subcategories.Count(); i++)
                {
                    scats.Add(subcategories[i]);
                    if(subcategories[i].SubAuditCategories != null && subcategories[i].SubAuditCategories.Count > 0)
                    {
                        GetSubCategories(subcategories[i].SubAuditCategories, cats, i, scats);
                    }
                }
                return scats;
            }
            else
            {
                return null;
            }
        }

        //private List<AuditCategoryApiReturnModel> GetSubsCategories(AuditCategoryApiReturnModel category, List<AuditCategoryApiReturnModel> cats, int index)
        //{
        //    List<AuditCategoryApiReturnModel> categories = new List<AuditCategoryApiReturnModel>();
        //    categories.Add(cats[index]);
        //    if (cats[index].SubAuditCategories != null && cats[index].SubAuditCategories.Count() > 0)
        //    {
        //        for (var i = 0; i < cats[index].SubAuditCategories.Count(); i++)
        //        {
        //            //GetSubCategories(cats[index].SubAuditCategories[i], cats[index].SubAuditCategories, i);
        //        }
        //    }
        //    return categories;
        //}

        private int GetStepOrder(string stepOrder)
        {
            int stepInt;

            int.TryParse(stepOrder, out stepInt);

            return stepInt;
        }

        public List<ConductForExportModel> GetConductDataForJson(ConductLinkEmailSendModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<ConductForExportModel> conductForExport = new List<ConductForExportModel>();

            try
            {
                List<ValidationMessage> validations = new List<ValidationMessage>();
                var auditConductApiInputModel = new AuditConductApiInputModel()
                {
                    AuditId = model.AuditId,
                    ConductId = model.ConductId
                };

                List<AuditConductApiReturnModel> conductSearchResults = SearchAuditConducts(auditConductApiInputModel, loggedInContext, validations);
                QuestionTypeApiInputModel questionTypeApiInputModel = new QuestionTypeApiInputModel()
                {
                    IsArchived = false
                };
                foreach (var conduct in conductSearchResults)
                {
                    AuditCategoryApiInputModel auditCategoryApiReturnModel = new AuditCategoryApiInputModel();

                    auditCategoryApiReturnModel.AuditId = model.AuditId;
                    auditCategoryApiReturnModel.ConductId = model.ConductId;

                    List<ConductCategoryForExport> SectionCasesList = new List<ConductCategoryForExport>();
                    var categories = SearchAuditCategories(auditCategoryApiReturnModel, loggedInContext, validations);
                    var subCategories = new List<AuditCategoryApiReturnModel>();
                    foreach (var c in categories)
                    {
                        if (c.SubAuditCategories.Count() > 0)
                        {
                            foreach (var sc in c.SubAuditCategories)
                            {
                                subCategories.Add(sc);
                            }
                        }
                    }

                    if (subCategories.Count() > 0)
                    {
                        categories.AddRange(subCategories);
                    }

                    foreach (var category in categories)
                    {
                        AuditQuestionsApiInputModel auditQuestionsApiInputModel = new AuditQuestionsApiInputModel();

                        auditQuestionsApiInputModel.AuditCategoryId = category.AuditCategoryId;
                        auditQuestionsApiInputModel.ConductId = model.ConductId;
                        var conductQuestions = SearchAuditConductQuestions(auditQuestionsApiInputModel, loggedInContext, validations);
                        List<ConductQuestionsForExport> questionsList = new List<ConductQuestionsForExport>();
                        foreach (var question in conductQuestions)
                        {
                            AuditQuestionsApiInputModel auditQuestionApiInputModel = new AuditQuestionsApiInputModel();

                            auditQuestionApiInputModel.QuestionId = question.QuestionId;
                            auditQuestionApiInputModel.ConductId = model.ConductId;
                            var conductQuestion = SearchAuditConductQuestions(auditQuestionApiInputModel, loggedInContext, validations).FirstOrDefault();
                            var questionData = new ConductQuestionsForExport();
                            questionData.QuestionName = conductQuestion?.QuestionName;
                            questionData.QuestionDescription = conductQuestion?.QuestionDescription;
                            questionData.CreatedDateTime = conductQuestion?.CreatedDateTime;
                            if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.TextQuestionTypeId.ToLower())
                            {
                                questionData.Result = conductQuestion?.QuestionResultText;
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.BooleanQuestionTypeId.ToLower())
                            {
                                questionData.Result = conductQuestion?.QuestionResult;
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.DateQuestionTypeId.ToLower())
                            {
                                questionData.Result = conductQuestion?.QuestionResultDate?.ToString("dddd, dd MMMM yyyy");
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.DropdownQuestionTypeId.ToLower())
                            {
                                questionData.Result = conductQuestion?.QuestionResult;
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.NumericQuestionTypeId.ToLower())
                            {
                                questionData.Result = conductQuestion?.QuestionResultNumeric.ToString();
                            }
                            else if (conductQuestion.MasterQuestionTypeId.ToString().ToLower() == AppConstants.TimeQuestionTypeId.ToLower())
                            {
                                questionData.Result = conductQuestion?.QuestionResultTime.ToString();
                            }

                            questionsList.Add(questionData);

                        }

                        SectionCasesList.Add(new ConductCategoryForExport()
                        {
                            CategoryName = category?.AuditCategoryName,
                            ParentCategoryName = category?.ParentAuditCategoryName,
                            CreatedDateTime = category?.CreatedDateTime,
                            Questions = questionsList?.OrderBy(p => p.CreatedDateTime).ToList()
                        });

                    }
                    conductForExport.Add(new ConductForExportModel()
                    {
                        ConductName = conduct?.AuditConductName,
                        CreatedDateTime = conduct?.CreatedDateTime,
                        Categories = SectionCasesList?.OrderBy(p => p.CreatedDateTime).ToList()
                    });
                }
                return conductForExport.OrderBy(p => p.CreatedDateTime).ToList();
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductDataForJson", "ComplianceAuditService ", exception.Message), exception);

                return conductForExport;
            }
        }

        public List<AuditForExportModel> GetAuditDataForJson(AuditDownloadModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<AuditForExportModel> testSuitesForExport = new List<AuditForExportModel>();

            try
            {
                List<ValidationMessage> validations = new List<ValidationMessage>();

                var auditComplianceApiInputModel = new AuditComplianceApiInputModel()
                {
                    AuditName = model?.AuditName?.Trim(),
                    IsArchived = false,
                    ProjectId = model?.ProjectId,
                    IsForFilter = model?.IsForFilter
                };

                List<AuditComplianceApiReturnModel> auditSearchResults = SearchAudits(auditComplianceApiInputModel, loggedInContext, validations);

                foreach (var audit in auditSearchResults)
                {

                    AuditCategoryApiInputModel auditCategoryApiReturnModel = new AuditCategoryApiInputModel();

                    auditCategoryApiReturnModel.AuditId = audit.AuditId;

                    List<CategoryForExport> SectionCasesList = new List<CategoryForExport>();
                    var categories = SearchAuditCategories(auditCategoryApiReturnModel, loggedInContext, validations);
                    var subCategories = new List<AuditCategoryApiReturnModel>();
                    var cats = new List<AuditCategoryApiReturnModel>();
                    for (var  i = 0; i < categories.Count(); i++)
                    {
                        //if (c.SubAuditCategories.Count() > 0)
                        //{
                        //    foreach (var sc in c.SubAuditCategories)
                        //    {
                        //        subCategories.Add(sc);
                        //    }
                        //}
                        cats.Add(categories[i]);
                        var scats = GetSubCategories(categories[i].SubAuditCategories, categories, i, new List<AuditCategoryApiReturnModel>());
                        if(scats != null)
                        {
                            cats.AddRange(scats);
                        }

                    }

                    //if (subCategories.Count() > 0)
                    //{
                    //    categories.AddRange(subCategories);
                    //}

                    foreach (var category in cats)
                    {
                        AuditQuestionsApiInputModel auditQuestionsApiInputModel = new AuditQuestionsApiInputModel();

                        auditQuestionsApiInputModel.AuditCategoryId = category.AuditCategoryId;

                        try
                        {
                            var questions = GetAuditQuestions(auditQuestionsApiInputModel, loggedInContext, validationMessages);

                            List<QuestionsForExport> questionsList = new List<QuestionsForExport>();

                            foreach (var question in questions)
                            {
                                AuditQuestionsApiInputModel auditQuestionsApiInputModelDetails = new AuditQuestionsApiInputModel();
                                auditQuestionsApiInputModelDetails.QuestionId = question.QuestionId;

                                try
                                {

                                    var questionsDetails = GetAuditQuestions(auditQuestionsApiInputModelDetails, loggedInContext, validationMessages);

                                    List<QuestionOptionsForExport> questionOptionsForExport;

                                    questionOptionsForExport = questionsDetails?[0].QuestionOptions?.Select(p => new QuestionOptionsForExport()
                                    {
                                        Result = p.QuestionOptionResult,
                                        Order = p.QuestionOptionOrder,
                                        OptionName = p.QuestionOptionName,
                                        OptionScore = p.QuestionOptionScore
                                    }).ToList();

                                    questionsList.Add(new QuestionsForExport
                                    {
                                        Type = questionsDetails?[0].QuestionTypeName,
                                        MasterQuestionTypeName = questionsDetails?[0].MasterQuestionTypeName,
                                        IsOriginalScore = questionsDetails?[0].IsOriginalQuestionTypeScore,
                                        lsMandatory = questionsDetails?[0].IsQuestionMandatory,
                                        Name = questionsDetails?[0].QuestionName,
                                        QuestionDescription = questionsDetails?[0].QuestionDescription,
                                        QuestionHint = questionsDetails?[0].QuestionHint,
                                        QuestionOptions = questionOptionsForExport?.ToList(),
                                        CreatedDateTime = questionsDetails?[0].CreatedDateTime
                                    });
                                }
                                catch
                                {
                                    var StaticValidation = new ValidationMessage
                                    {
                                        ValidationMessaage = string.Format(ValidationMessages.ExceptionGetAuditCategories, question.QuestionId),
                                        ValidationMessageType = MessageTypeEnum.Error
                                    };
                                    validationMessages.Add(StaticValidation);
                                    validations.Clear();
                                }
                            }

                            SectionCasesList.Add(new CategoryForExport
                            {

                                CategoryName = category.AuditCategoryName,
                                ParentCategoryName = category.ParentAuditCategoryName,
                                Description = category.AuditCategoryDescription,
                                CreatedDateTime = category.CreatedDateTime,
                                Questions = questionsList?.OrderBy(p => p.CreatedDateTime).ToList()
                            });

                        }
                        catch
                        {
                            var staticValidation = new ValidationMessage
                            {
                                ValidationMessaage = string.Format(ValidationMessages.ExceptionGetAuditCategories, category.AuditCategoryId),
                                ValidationMessageType = MessageTypeEnum.Error
                            };
                            validationMessages.Add(staticValidation);
                            validations.Clear();
                        }
                    }

                    testSuitesForExport.Add(new AuditForExportModel
                    {
                        AuditName = audit.AuditName,
                        Description = audit.AuditDescription,
                        CreatedDateTime = audit.CreatedDateTime,
                        Categories = SectionCasesList?.OrderBy(p => p.CreatedDateTime).ToList()

                    });

                }
                return testSuitesForExport.OrderBy(p => p.CreatedDateTime).ToList();
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditDataForJson", "ComplianceAuditService ", exception.Message), exception);

                return testSuitesForExport;
            }

        }

        public byte[] GetConductDataForExcel(List<ConductForExportModel> conducts, ConductLinkEmailSendModel exportModel, string site, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            byte[] result = null;

            if (conducts == null || !conducts.Any())
            {
                return null;
            }

            try
            {
                using (var memoryStream = new MemoryStream())
                {
                    using (var spreadSheet = SpreadsheetDocument.Create(memoryStream, SpreadsheetDocumentType.Workbook))
                    {
                        InsertConducts(spreadSheet, conducts);

                        spreadSheet.WorkbookPart.Workbook.Save();
                    }

                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, site);

                    SpreadsheetDocument.Open(memoryStream, false);

                    CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                    var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                    companySettingsSearchInputModel.CompanyId = companyModel?.CompanyId;
                    companySettingsSearchInputModel.IsSystemApp = null;
                    string storageAccountName = string.Empty;

                    List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                    if (companySettings.Count > 0)
                    {
                        var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                        storageAccountName = storageAccountDetails?.Value;
                    }

                    var directory = SetupCompanyFileContainer(companyModel, 12, loggedInContext.LoggedInUserId, storageAccountName);

                    var fileName = exportModel.ConductName;

                    LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                    fileName = fileName.Replace(" ", "_");

                    var fileExtension = ".xlsx";

                    var convertedFileName = fileName + "-" + Guid.NewGuid() + fileExtension;

                    CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                    blockBlob.Properties.CacheControl = "public, max-age=2592000";

                    blockBlob.Properties.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                    Byte[] bytes = memoryStream?.ToArray();

                    blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                    var fileurl = blockBlob.Uri.AbsoluteUri;

                    var toEmails = (exportModel.ToMails == null || exportModel.ToMails.Trim() == "") ? null : exportModel.ToMails.Trim().Split('\n');

                    var html = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />";
                    html += "<style type=\"text/css\">* {-webkit-font-smoothing: antialiased;}body {Margin: 0;padding: 0;min-width: 100%;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;mso-line-height-rule: exactly;}";
                    html += "table {border-spacing: 0;color: #333333;font-family: Arial, sans-serif;}img {border: 0;}.wrapper { width: 100%;table-layout: fixed;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}.webkit { max-width: 600px;}.outer {Margin: 0 auto;width: 100%;max-width: 600px;}.full-width-image img {width: 100%;max-width: 600px; height: auto;}.inner { padding: 10px;}p {Margin: 0;padding-bottom: 10px;}.h1 { font-size: 21px;font-weight: bold; Margin-top: 15px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.h2 {font-size: 18px;font-weight: bold;Margin-top: 10px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column .contents {text-align: left;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column p {font-size: 14px;Margin-bottom: 10px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.two-column {text-align: center;font-size: 0;}.two-column .column {width: 100%;max-width: 300px;display: inline-block;vertical-align: top;}.contents {width: 100%;}.two-column .contents {font-size: 14px;text-align: left;}.two-column img {width: 100%;max-width: 280px;height: auto;}.two-column .text {padding-top: 10px;}.three-column {text-align: center;font-size: 0;padding-top: 10px;padding-bottom: 10px;}.three-column .column {width: 100%;max-width: 200px;display: inline-block;vertical-align: top;}.three-column .contents {font-size: 14px;text-align: center;}.three-column img {width: 100%;max-width: 180px;height: auto;}.three-column .text {padding-top: 10px;}.img-align-vertical img {display: inline-block;vertical-align: middle;}@@media only screen and (max-device-width: 480px) {table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}</style></head><bodystyle=\"Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;\"><center class=\"wrapper\"style=\"width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color:#f3f2f0;\"bgcolor=\"#f3f2f0;\"><tr><td width=\"100%\"><div class=\"webkit\" style=\"max-width:600px;Margin:0 auto;\"><table class=\"outer\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"style=\"border-spacing:0;Margin:0 auto;width:100%;max-width:600px;\"><tr><td style=\"padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;\"><table class=\"one-column\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"style=\"border-spacing:0; border-left:1px solid #e8e7e5; ";
                    html += "border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5\"bgcolor=\"#FFFFFF\"><tr><td align=\"left\" style=\"padding:50px 50px 50px 50px\"><p style=\"color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif\"><h2>Dear,</h2></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future. <a target=\"_blank\" href=\"##PdfUrl##\" style=\"color: #099\">Clickhere</a> to download the exported conduct file.<br /><br /></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Best Regards, <br />##footerName##</p></td></tr></table></td></tr></table></div></td></tr></table></center></body></html>";
                    var exportHtml = html.Replace("##PdfUrl##", fileurl);

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmails,
                            HtmlContent = exportHtml,
                            Subject = "Snovasys Business Suite: Export Mail Template",
                            CCMails = null,
                            BCCMails = null,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });

                    result = memoryStream.ToArray();

                    return result;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductDataForExcel", "ComplianceAuditService ", exception.Message), exception);

                throw;
            }
        }

        private void InsertConducts(SpreadsheetDocument spreadSheet, List<ConductForExportModel> conducts)
        {
            foreach (var conduct in conducts)
            {
                conduct.ConductName = conduct.ConductName?.EndsWith(".") == true ? conduct.ConductName.Remove(conduct.ConductName.Length - 1, 1) : conduct.ConductName;

                WorksheetPart worksheetPart = OpenXmlHelper.InsertWorksheet(spreadSheet, conduct.ConductName, 1);

                InsertConduct(spreadSheet, worksheetPart, conduct);
            }
        }

        private void InsertConduct(SpreadsheetDocument spreadSheet, WorksheetPart worksheetPart, ConductForExportModel conduct)
        {

            var sectionList = new List<CategoryForExport>();

            uint rowNo = 1;
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "SNo", "A", rowNo, "no", "no", false, 10);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "CONDUCT NAME", "B", rowNo, "no", "no", false, 10);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "CATEGORY", "C", rowNo, "no", "no", false, 30);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "PARENT CATEGORY", "D", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "CATEGORY PATH", "E", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "QUESTION NAME", "F", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "QUESTION ANSWER", "G", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "QUESTION DESCRIPTION", "H", rowNo, "no", "no", false, 50);
            rowNo = 2;
            int sNo = 1;
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, sNo.ToString() ?? string.Empty, "A", rowNo);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, conduct.ConductName ?? string.Empty, "B", rowNo);
            foreach (var section in conduct.Categories)
            {
                section.CategoryName = section.CategoryName?.EndsWith(".") == true ? section.CategoryName.Remove(section.CategoryName.Length - 1, 1) : section.CategoryName;
                var sectionObject = sectionList.FirstOrDefault(x => x.CategoryName == section.CategoryName && x.ParentCategoryName == section.ParentCategoryName);
                if (sectionObject == null)
                {
                    sectionObject = new CategoryForExport { CategoryName = section.CategoryName, ParentCategoryName = section.ParentCategoryName };
                    sectionList.Add(sectionObject);
                }
                var sNoStr = sNo.ToString();
                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, section.CategoryName ?? string.Empty, "C", rowNo);
                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, section.ParentCategoryName ?? string.Empty, "D", rowNo);
                var testRepositoryPath = "/" + conduct.ConductName + "/" + GetRepositoryPath(sectionList, section.ParentCategoryName, section.CategoryName);
                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testRepositoryPath ?? string.Empty, "E", rowNo);
                foreach (var question in section.Questions)
                {                   
                    var testCaseTitle = question.QuestionName?.EndsWith(".") == true ? question.QuestionName.Remove(question.QuestionName.Length - 1, 1) : question.QuestionName;
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCaseTitle ?? string.Empty, "F", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, question.Result ?? string.Empty, "G", rowNo);
                    OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, question.QuestionDescription ?? string.Empty, "H", rowNo);

                    rowNo++;
                    sNo++;

                } // foreach (var question in category.questions)

            } // foreach(var category in audit.categories)

            worksheetPart.Worksheet.Save();
        }



        public byte[] GetAuditDataForExcel(List<AuditForExportModel> audits, AuditDownloadModel exportModel, string site, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            byte[] result = null;

            if (audits == null || !audits.Any())
            {
                return null;
            }

            try
            {
                using (var memoryStream = new MemoryStream())
                {
                    using (var spreadSheet = SpreadsheetDocument.Create(memoryStream, SpreadsheetDocumentType.Workbook))
                    {
                        InsertAudits(spreadSheet, audits);

                        spreadSheet.WorkbookPart.Workbook.Save();
                    }

                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, site);

                    SpreadsheetDocument.Open(memoryStream, false);

                    CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                    var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                    companySettingsSearchInputModel.CompanyId = companyModel?.CompanyId;
                    companySettingsSearchInputModel.IsSystemApp = null;

                    string storageAccountName = string.Empty;

                    List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                    if (companySettings.Count > 0)
                    {
                        var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                        storageAccountName = storageAccountDetails?.Value;
                    }

                    var directory = SetupCompanyFileContainer(companyModel, 11, loggedInContext.LoggedInUserId, storageAccountName);

                    var fileName = exportModel.AuditName ?? "Audits";

                    LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                    fileName = fileName.Replace(" ", "_");

                    var fileExtension = ".xlsx";

                    var convertedFileName = fileName + "-" + Guid.NewGuid() + fileExtension;

                    CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                    blockBlob.Properties.CacheControl = "public, max-age=2592000";

                    blockBlob.Properties.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                    Byte[] bytes = memoryStream?.ToArray();

                    blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                    var fileurl = blockBlob.Uri.AbsoluteUri;

                    var toEmails = (exportModel.ToMails == null || exportModel.ToMails.Trim() == "") ? null : exportModel.ToMails.Trim().Split('\n');

                    var html = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />";
                    html += "<style type=\"text/css\">* {-webkit-font-smoothing: antialiased;}body {Margin: 0;padding: 0;min-width: 100%;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;mso-line-height-rule: exactly;}";
                    html += "table {border-spacing: 0;color: #333333;font-family: Arial, sans-serif;}img {border: 0;}.wrapper { width: 100%;table-layout: fixed;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}.webkit { max-width: 600px;}.outer {Margin: 0 auto;width: 100%;max-width: 600px;}.full-width-image img {width: 100%;max-width: 600px; height: auto;}.inner { padding: 10px;}p {Margin: 0;padding-bottom: 10px;}.h1 { font-size: 21px;font-weight: bold; Margin-top: 15px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.h2 {font-size: 18px;font-weight: bold;Margin-top: 10px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column .contents {text-align: left;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column p {font-size: 14px;Margin-bottom: 10px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.two-column {text-align: center;font-size: 0;}.two-column .column {width: 100%;max-width: 300px;display: inline-block;vertical-align: top;}.contents {width: 100%;}.two-column .contents {font-size: 14px;text-align: left;}.two-column img {width: 100%;max-width: 280px;height: auto;}.two-column .text {padding-top: 10px;}.three-column {text-align: center;font-size: 0;padding-top: 10px;padding-bottom: 10px;}.three-column .column {width: 100%;max-width: 200px;display: inline-block;vertical-align: top;}.three-column .contents {font-size: 14px;text-align: center;}.three-column img {width: 100%;max-width: 180px;height: auto;}.three-column .text {padding-top: 10px;}.img-align-vertical img {display: inline-block;vertical-align: middle;}@@media only screen and (max-device-width: 480px) {table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}</style></head><bodystyle=\"Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;\"><center class=\"wrapper\"style=\"width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color:#f3f2f0;\"bgcolor=\"#f3f2f0;\"><tr><td width=\"100%\"><div class=\"webkit\" style=\"max-width:600px;Margin:0 auto;\"><table class=\"outer\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"style=\"border-spacing:0;Margin:0 auto;width:100%;max-width:600px;\"><tr><td style=\"padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;\"><table class=\"one-column\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"style=\"border-spacing:0; border-left:1px solid #e8e7e5; ";
                    html += "border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5\"bgcolor=\"#FFFFFF\"><tr><td align=\"left\" style=\"padding:50px 50px 50px 50px\"><p style=\"color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif\"><h2>Dear,</h2></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future. <a target=\"_blank\" href=\"##PdfUrl##\" style=\"color: #099\">Clickhere</a> to download the exported audit file.<br /><br /></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Best Regards, <br />##footerName##</p></td></tr></table></td></tr></table></div></td></tr></table></center></body></html>";
                    var exportHtml = html.Replace("##PdfUrl##", fileurl);

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmails,
                            HtmlContent = exportHtml,
                            Subject = "Snovasys Business Suite: Export Mail Template",
                            CCMails = null,
                            BCCMails = null,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });

                    result = memoryStream.ToArray();

                    return result;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditDataForExcel", "ComplianceAuditService ", exception.Message), exception);

                throw;
            }
        }

        private void InsertAudits(SpreadsheetDocument spreadSheet, List<AuditForExportModel> audits)
        {
            foreach (var audit in audits)
            {
                audit.AuditName = audit.AuditName?.EndsWith(".") == true ? audit.AuditName.Remove(audit.AuditName.Length - 1, 1) : audit.AuditName;

                WorksheetPart worksheetPart = OpenXmlHelper.InsertWorksheet(spreadSheet, audit.AuditName, 1);

                InsertAudit(spreadSheet, worksheetPart, audit);
            }
        }
        private void InsertAudit(SpreadsheetDocument spreadSheet, WorksheetPart worksheetPart, AuditForExportModel audit)
        {

            var sectionList = new List<CategoryForExport>();

            uint rowNo = 1;
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "SNo", "A", rowNo, "no", "no", false, 10);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "CATEGORY", "B", rowNo, "no", "no", false, 30);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "PARENT CATEGORY", "C", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "CATEGORY PATH", "D", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "TYPE", "E", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "NAME", "F", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Score", "G", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "OptionName", "H", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "OptionOrder", "I", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "OptionScore", "J", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "OptionResult", "K", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "QuestionDescription", "L", rowNo, "no", "no", false, 50);
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "Audit", "M", rowNo, "no", "no", false, 10);
            rowNo = 2;
            int sNo = 1;
            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, audit.AuditName ?? string.Empty, "M", rowNo);
            foreach (var section in audit.Categories)
            {
                section.CategoryName = section.CategoryName?.EndsWith(".") == true ? section.CategoryName.Remove(section.CategoryName.Length - 1, 1) : section.CategoryName;
                var sectionObject = sectionList.FirstOrDefault(x => x.CategoryName == section.CategoryName && x.ParentCategoryName == section.ParentCategoryName);
                if (sectionObject == null)
                {
                    sectionObject = new CategoryForExport { CategoryName = section.CategoryName, ParentCategoryName = section.ParentCategoryName };
                    sectionList.Add(sectionObject);
                }
                var sNoStr = sNo.ToString();
                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, sNoStr ?? string.Empty, "A", rowNo);
                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, section.CategoryName ?? string.Empty, "B", rowNo);
                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, section.ParentCategoryName ?? string.Empty, "C", rowNo);
                var testRepositoryPath = "/" + audit.AuditName + "/" + GetRepositoryPath(sectionList, section.ParentCategoryName, section.CategoryName);
                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testRepositoryPath ?? string.Empty, "D", rowNo);
                if (section.Questions.Count() > 0)
                {
                    foreach (var question in section.Questions)
                    {
                        var masterQType = Regex.Match(question.Type, @"(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}",
                        RegexOptions.IgnoreCase);
                        var questionOptions = question.QuestionOptions != null ? question.QuestionOptions : new List<QuestionOptionsForExport>();
                        OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, masterQType.Success ? question.MasterQuestionTypeName : question.Type, "E", rowNo);
                        var testCaseTitle = question.Name?.EndsWith(".") == true ? question.Name.Remove(question.Name.Length - 1, 1) : question.Name;
                        OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testCaseTitle ?? string.Empty, "F", rowNo);
                        OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, question.Score.ToString(), "G", rowNo);
                        OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, question.QuestionDescription ?? string.Empty, "L", rowNo);
                        //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, string.Empty, "E", rowNo);

                        //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, question.QuestionDescription ?? string.Empty, "G", rowNo);
                        //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, "To Do", "H", rowNo);

                        //OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, question.MasterQuestionTypeName ?? string.Empty, "K", rowNo);

                        for (int i = 0; i < questionOptions.Count(); i++)
                        {
                            var testStep = questionOptions[i];

                            if (i > 0)
                            {
                                rowNo++;
                                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.OptionName ?? string.Empty, "H", rowNo);
                                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.Order.ToString(), "I", rowNo);
                                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.OptionScore.ToString(), "J", rowNo);
                                OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.Result.ToString(), "K", rowNo);
                            }
                            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.OptionName ?? string.Empty, "H", rowNo);
                            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.Order.ToString(), "I", rowNo);
                            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.OptionScore.ToString(), "J", rowNo);
                            OpenXmlHelper.AppendCell(spreadSheet.WorkbookPart, worksheetPart, testStep.Result.ToString(), "K", rowNo);
                        }

                        rowNo++;
                        sNo++;

                    } // foreach (var question in category.questions)
                } 
                else
                {
                    rowNo++;
                    sNo++;
                }

            } // foreach(var category in audit.categories)

            worksheetPart.Worksheet.Save();
        }
        private string GetRepositoryPath(List<CategoryForExport> sectionList, string parentSectionName, string path)
        {
            var section = sectionList.FirstOrDefault(x => x.CategoryName == parentSectionName);
            if (section != null)
            {
                path = section.CategoryName + "/" + path;
                return GetRepositoryPath(sectionList, section.ParentCategoryName, path);
            }

            return path;
        }
        private CloudBlobDirectory SetupCompanyFileContainer(CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId, string storageAccountName)
        {
            LoggingManager.Info("SetupCompanyFileContainer");

            CloudStorageAccount storageAccount = StorageAccount(storageAccountName);

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            Regex re = new Regex(@"(^{[&\/\\#,+()$~%._\'"":*?<>{}@`;^=-]})$");

            companyModel.CompanyName = companyModel.CompanyName.Replace(" ", string.Empty);

            string companyName = re.Replace(companyModel.CompanyName, "");

            string company = (companyModel.CompanyId.ToString()).ToLower();

            CloudBlobContainer container = blobClient.GetContainerReference(company);

            try
            {
                bool isCreated = container.CreateIfNotExists();
                if (isCreated == true)
                {
                    Console.WriteLine("Created container {0}", container.Name);

                    container.SetPermissions(new BlobContainerPermissions
                    {
                        PublicAccess = BlobContainerPublicAccessType.Blob
                    });
                }
            }

            catch (StorageException e)
            {
                Console.WriteLine("HTTP error code {0}: {1}", e.RequestInformation.HttpStatusCode, e.RequestInformation.ErrorCode);

                Console.WriteLine(e.Message);

                throw;
            }

            string directoryReference = moduleTypeId == (int)ModuleTypeEnum.Hrm ? AppConstants.HrmBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Assets ? AppConstants.AssetsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.FoodOrder ? AppConstants.FoodOrderBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Projects ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Invoices ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.TestRepo ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Audits ? AppConstants.AuditsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Conducts ? AppConstants.ConductsBlobDirectoryReference : AppConstants.LocalBlobContainerReference;

            CloudBlobDirectory moduleDirectory = container.GetDirectoryReference(directoryReference);

            CloudBlobDirectory userLevelDirectory = moduleDirectory.GetDirectoryReference(loggedInUserId.ToString());

            return userLevelDirectory;
        }
        private CloudStorageAccount StorageAccount(string storageAccountName)
        {
            LoggingManager.Debug("Entering into GetStorageAccount method of blob service");
            string account;
            if (string.IsNullOrEmpty(storageAccountName))
            {
                account = CloudConfigurationManager.GetSetting("StorageAccountName");
            }
            else
            {
                account = storageAccountName;
            }
            string key = CloudConfigurationManager.GetSetting("StorageAccountAccessKey");
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

            return storageAccount;
        }

        public Guid? InsertAuditVersion(InsertAuditVersionInputModel insertAuditVersionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertAuditVersion", "ComplianceAudit Service"));

            Guid? auditVersionId = _complianceAuditRepository.InsertAuditVersion(insertAuditVersionInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBranchCommandId, insertAuditVersionInputModel, loggedInContext);

            LoggingManager.Debug(auditVersionId?.ToString());

            return auditVersionId;
        }

        public List<GetAuditVersionsOutputModel> GetAuditVersions(Guid? auditId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertAuditVersion", "ComplianceAudit Service"));

            List<GetAuditVersionsOutputModel> auditVersions = _complianceAuditRepository.GetAuditVersions(auditId, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBranchCommandId, auditId, loggedInContext);

            LoggingManager.Debug(auditId?.ToString());

            return auditVersions;
        }
    }
}