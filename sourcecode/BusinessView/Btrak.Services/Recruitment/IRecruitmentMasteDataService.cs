using Btrak.Models;
using Btrak.Models.Recruitment;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Recruitment
{
    public interface IRecruitmentMasterDataService
    {
        List<JobOpeningStatusSearchOutputModel> GetJobOpeningStatus(JobOpeningStatusSearchInputModel jobOpeningStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertJobOpeningStatus(JobOpeningStatusUpsertInputModel jobOpeningStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<JobTypeSearchOutputModel> GetJobTypes(JobTypesSearchInputModel jobTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertJobType(JobTypeUpsertInputModel jobTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<SourceSearchOutputModel> GetSources(SourceSearchInputModel sourceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSource(SourceUpsertInputModel sourceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DocumentTypesSearchOutputModel> GetDocumentTypes(DocumentTypesSearchInputModel documentTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertDocumentType(DocumentTypeUpsertInputModel documentTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InterviewTypesSearchOutputModel> GetInterviewTypes(InterviewTypesSearchInputModel interviewTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertInterviewType(InterviewTypeUpsertInputModel interviewTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertHiringStatus(HiringStatusUpsertInputModel hiringStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<HiringStatusSearchOutputModel> GetHiringStatus(HiringStatusSearchInputModel hiringStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InterviewRatingSearchOutputModel> GetInterviewRatings(InterviewRatingSearchInputModel interviewRatingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertInterviewRating(InterviewRatingUpsertInputModel interviewRatingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ScheduleStatusSearchOutputModel> GetScheduleStatus(ScheduleStatusSearchInputModel scheduleStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object GetCandidateRegistrationDropDown(Guid jobOpeningId, string type, List<ValidationMessage> validationMessages);
        LoggedInContext GetLoggedInContextForCandidate(Guid jobOpeningId, string type, List<ValidationMessage> validationMessages);
    }
}
