using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructureManagement;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.Recruitment;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructureManagement;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.RecruitmentHelper;
using Btrak.Services.HrManagement;
using Btrak.Services.MasterData;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.Recruitment
{
    public class RecruitmentMasterDataService : IRecruitmentMasterDataService
    {
        private readonly RecruitmentMasterDataRepository _recruitmentMasterDataRepository;
        private readonly HrManagementService _hrManagementService;
        private readonly MasterDataManagementService _masterDataManagementService;
        private readonly CompanyStructureManagementService _companyStructureManagementService;
        private readonly IAuditService _auditService;

        public RecruitmentMasterDataService(RecruitmentMasterDataRepository recruitmentMasterDataRepository, IAuditService auditService, HrManagementService hrManagementService,
                MasterDataManagementService masterDataManagementService, CompanyStructureManagementService companyStructureManagementService)
        {
            _recruitmentMasterDataRepository = recruitmentMasterDataRepository;
            _auditService = auditService;
            _hrManagementService = hrManagementService;
            _masterDataManagementService = masterDataManagementService;
            _companyStructureManagementService = companyStructureManagementService;
        }

        public Guid? UpsertJobOpeningStatus(JobOpeningStatusUpsertInputModel jobOpeningStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Job Opening Status", "Recruitment Service"));
            LoggingManager.Debug(jobOpeningStatusUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertJobOpeningStatusCommandId, jobOpeningStatusUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.UpsertJobOpeningStatusValidation(jobOpeningStatusUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            jobOpeningStatusUpsertInputModel.JobOpeningStatusId = _recruitmentMasterDataRepository.UpsertJobOpeningStatus(jobOpeningStatusUpsertInputModel, loggedInContext, validationMessages);
            return jobOpeningStatusUpsertInputModel.JobOpeningStatusId;
        }

        public List<JobOpeningStatusSearchOutputModel> GetJobOpeningStatus(JobOpeningStatusSearchInputModel jobOpeningStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetJobOpeningStatus", "Recruitment Service"));
            LoggingManager.Debug(jobOpeningStatusSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetJobOpeningStatusCommandId, jobOpeningStatusSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<JobOpeningStatusSearchOutputModel> JobOpeningStatus = _recruitmentMasterDataRepository.GetJobOpeningStatus(jobOpeningStatusSearchInputModel, loggedInContext, validationMessages).ToList();
            return JobOpeningStatus;
        }

        public Guid? UpsertJobType(JobTypeUpsertInputModel jobTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Job Opening Status", "Recruitment Service"));
            LoggingManager.Debug(jobTypeUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertJobOpeningStatusCommandId, jobTypeUpsertInputModel, loggedInContext);
            //if (!RecruitmentValidationHelper.UpsertJobType(jobTypeUpsertInputModel, loggedInContext, validationMessages))
            //{
            //    return null;
            //}
            jobTypeUpsertInputModel.JobTypeId = _recruitmentMasterDataRepository.UpsertJobType(jobTypeUpsertInputModel, loggedInContext, validationMessages);
            return jobTypeUpsertInputModel.JobTypeId;
        }

        public List<JobTypeSearchOutputModel> GetJobTypes(JobTypesSearchInputModel jobTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetJobOpeningStatus", "Recruitment Service"));
            LoggingManager.Debug(jobTypesSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetJobTypesCommandId, jobTypesSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<JobTypeSearchOutputModel> JobTypes = _recruitmentMasterDataRepository.GetJobTypes(jobTypesSearchInputModel, loggedInContext, validationMessages).ToList();
            return JobTypes;
        }

        public Guid? UpsertSource(SourceUpsertInputModel SourceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Job Source", "Recruitment Service"));
            LoggingManager.Debug(SourceUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertSourceCommandId, SourceUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.UpsertSourceValidation(SourceUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            SourceUpsertInputModel.SourceId = _recruitmentMasterDataRepository.UpsertSource(SourceUpsertInputModel, loggedInContext, validationMessages);
            return SourceUpsertInputModel.SourceId;
        }

        public List<SourceSearchOutputModel> GetSources(SourceSearchInputModel SourceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSource", "Recruitment Service"));
            LoggingManager.Debug(SourceSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetSourceCommandId, SourceSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<SourceSearchOutputModel> Source = _recruitmentMasterDataRepository.GetSources(SourceSearchInputModel, loggedInContext, validationMessages).ToList();
            return Source;
        }

        public Guid? UpsertDocumentType(DocumentTypeUpsertInputModel documentTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCandidateDocument", "Recruitment Service"));
            LoggingManager.Debug(documentTypeUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertDocumentTypeCommandId, documentTypeUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.DocumentTypeUpsertInputModel(documentTypeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            documentTypeUpsertInputModel.DocumentTypeId = _recruitmentMasterDataRepository.UpsertDocumentType(documentTypeUpsertInputModel, loggedInContext, validationMessages);
            return documentTypeUpsertInputModel.DocumentTypeId;
        }

        public List<DocumentTypesSearchOutputModel> GetDocumentTypes(DocumentTypesSearchInputModel documentTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateDocuments", "Recruitment Service"));
            LoggingManager.Debug(documentTypesSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetDocumentTypesCommandId, documentTypesSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<DocumentTypesSearchOutputModel> DocumentTypes = _recruitmentMasterDataRepository.GetDocumentTypes(documentTypesSearchInputModel, loggedInContext, validationMessages).ToList();
            return DocumentTypes;
        }

        public Guid? UpsertInterviewType(InterviewTypeUpsertInputModel interviewTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewType", "Recruitment Service"));
            LoggingManager.Debug(interviewTypeUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertInterviewTypeCommandId, interviewTypeUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.InterviewTypeUpsertInputModel(interviewTypeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (interviewTypeUpsertInputModel.RoleId?.Count > 0 && interviewTypeUpsertInputModel.RoleId != null)
            {
                interviewTypeUpsertInputModel.RoleIds = Utilities.ConvertIntoListXml(interviewTypeUpsertInputModel.RoleId);
            }

            interviewTypeUpsertInputModel.InterviewTypeId = _recruitmentMasterDataRepository.UpsertInterviewType(interviewTypeUpsertInputModel, loggedInContext, validationMessages);
            return interviewTypeUpsertInputModel.InterviewTypeId;
        }

        public List<InterviewTypesSearchOutputModel> GetInterviewTypes(InterviewTypesSearchInputModel interviewTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewTypes", "Recruitment Service"));
            LoggingManager.Debug(interviewTypesSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetInterviewTypesCommandId, interviewTypesSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<InterviewTypesSearchOutputModel> interviewTypes = _recruitmentMasterDataRepository.GetInterviewTypes(interviewTypesSearchInputModel, loggedInContext, validationMessages).ToList();
            return interviewTypes;
        }
        
        public Guid? UpsertHiringStatus(HiringStatusUpsertInputModel hiringStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertHiringStatus", "Recruitment Service"));
            LoggingManager.Debug(hiringStatusUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertHiringStatusCommandId, hiringStatusUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.HiringStatusUpsertInputModel(hiringStatusUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            hiringStatusUpsertInputModel.HiringStatusId = _recruitmentMasterDataRepository.UpsertHiringStatus(hiringStatusUpsertInputModel, loggedInContext, validationMessages);
            return hiringStatusUpsertInputModel.HiringStatusId;
        }

        public List<HiringStatusSearchOutputModel> GetHiringStatus(HiringStatusSearchInputModel hiringStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHiringStatus", "Recruitment Service"));
            LoggingManager.Debug(hiringStatusSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetHiringStatusCommandId, hiringStatusSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<HiringStatusSearchOutputModel> hiringStatus = _recruitmentMasterDataRepository.GetHiringStatus(hiringStatusSearchInputModel, loggedInContext, validationMessages).ToList();
            return hiringStatus;
        }

        public Guid? UpsertInterviewRating(InterviewRatingUpsertInputModel interviewRatingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewRating", "Recruitment Service"));
            LoggingManager.Debug(interviewRatingUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertInterviewRatingCommandId, interviewRatingUpsertInputModel, loggedInContext);
            if (!RecruitmentValidationHelper.InterviewRatingUpsertInputModel(interviewRatingUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            interviewRatingUpsertInputModel.InterviewRatingId = _recruitmentMasterDataRepository.UpsertInterviewRating(interviewRatingUpsertInputModel, loggedInContext, validationMessages);
            return interviewRatingUpsertInputModel.InterviewRatingId;
        }

        public List<InterviewRatingSearchOutputModel> GetInterviewRatings(InterviewRatingSearchInputModel interviewRatingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewRatings", "Recruitment Service"));
            LoggingManager.Debug(interviewRatingSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetInterviewRatingsCommandId, interviewRatingSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<InterviewRatingSearchOutputModel> interviewRatings = _recruitmentMasterDataRepository.GetInterviewRatings(interviewRatingSearchInputModel, loggedInContext, validationMessages).ToList();
            return interviewRatings;
        }

        public List<ScheduleStatusSearchOutputModel> GetScheduleStatus(ScheduleStatusSearchInputModel scheduleStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetScheduleStatus", "Recruitment Service"));
            LoggingManager.Debug(scheduleStatusSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetScheduleStatusCommandId, scheduleStatusSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ScheduleStatusSearchOutputModel> scheduleStatus = _recruitmentMasterDataRepository.GetScheduleStatus(scheduleStatusSearchInputModel, loggedInContext, validationMessages).ToList();
            return scheduleStatus;
        }

        public object GetCandidateRegistrationDropDown(Guid jobOpeningId, string type, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateRegistrationDropDown", "Recruitment MasterData Service"));
            LoggedInContext loggedInContext = _recruitmentMasterDataRepository.GetCandidateRegistrationDropDown(jobOpeningId, type, validationMessages);
            if (type == "designation")
            {
                return _hrManagementService.GetDesignations(new DesignationSearchInputModel(), loggedInContext, validationMessages);
            }
            else if (type == "state")
            {
                return _masterDataManagementService.GetStates(new GetStatesSearchCriteriaInputModel(), loggedInContext, validationMessages);
            }
            else if (type == "country")
            {
                return _companyStructureManagementService.GetCountries(new CountrySearchInputModel(), validationMessages, loggedInContext);
            }
            else if(type == "skills")
            {
                return _masterDataManagementService.GetSkills(new SkillsSearchCriteriaInputModel(), loggedInContext, validationMessages);
            }
            else if(type == "documents")
            {
                return GetDocumentTypes(new DocumentTypesSearchInputModel(), loggedInContext, validationMessages);
            }
            else
            {
                return null;
            }
        }

        public LoggedInContext GetLoggedInContextForCandidate(Guid jobOpeningId, string type, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLoggedInContextForCandidate", "Recruitment MasterData Service"));
            return _recruitmentMasterDataRepository.GetCandidateRegistrationDropDown(jobOpeningId, type, validationMessages);
        }
    }
}
