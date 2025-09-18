using Btrak.Models;
using Btrak.Models.GenericForm;
using Btrak.Models.Recruitment;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Recruitment
{
    public interface IRecruitmentService
    {
        Guid? UpsertCandidate(CandidateUpsertInputModel candidateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertCandidateFormSubmitted(GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, List<ValidationMessage> validationMessages);
        Guid? UpsertCandidateJob(CandidateUpsertInputModel candidateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidatesSearchOutputModel> GetCandidates(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidatesSearchOutputModel> GetCandidatesBySkill(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BrytumViewJobDetailsOutputModel> GetBrytumViewJobDetails(JobOpeningsSearchInputModel jobOpeningsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<JobOpeningsSearchOutputModel> GetJobOpenings(JobOpeningsSearchInputModel jobOpeningsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertJobOpening(JobOpeningUpsertInputModel jobOpeningUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<JobOpeningSkillsSearchOutputModel> GetJobOpeningSkills(JobOpeningSkillsSearchInputModel jobOpeningSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertJobOpeningSkill(JobOpeningSkillUpsertInputModel jobOpeningSkillUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateSkillsSearchOutputModel> GetCandidateSkills(CandidateSkillsSearchInputModel candidateSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCandidateSkill(CandidateSkillUpsertInputModel candidateSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCandidateExperience(CandidateExperienceUpsertInputModel candidateExperienceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateExperienceSearchOutputModel> GetCandidateExperience(CandidateExperienceSearchInputModel candidateExperienceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateEducationSearchOutputModel> GetCandidateEducation(CandidateEducationSearchInputModel candidateEducationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCandidateEducation(CandidateEducationUpsertInputModel candidateEducationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCandidateDocument(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateDocumentsSearchOutputModel> GetCandidateDocuments(CandidateDocumentsSearchInputModel candidateDocumentsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InterviewProcessSearchOutputModel> GetInterviewprocess(InterviewProcessSearchInputModel interviewProcessSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertInterviewProcess(InterviewProcessUpsertInputModel interviewProcessUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertInterviewProcessConfiguration(InterviewProcessConfigurationUpsertInputModel interviewProcessConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InterviewProcessConfigurationSearchOutputModel> GetInterviewprocessConfiguration(InterviewProcessConfigurationSearchInputModel interviewProcessConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCandidateInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ApproveCandidateInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateInterviewScheduleSearchOutputModel> GetCandidateInterviewSchedule(CandidateInterviewScheduleSearchInputModel candidateInterviewScheduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateInterviewScheduleSearchOutputModel> GetCandidateInterviewer(CandidateInterviewScheduleSearchInputModel candidateInterviewScheduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCandidateInterviewFeedBack(CandidateInterviewFeedBackUpsertInputModel candidateInterviewFeedBackUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateInterviewFeedbackSearchOutputModel> GetCandidateInterviewFeedBack(CandidateInterviewFeedbackSearchInputModel candidateInterviewFeedbackSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCandidateInterviewFeedBackComments(CandidateInterviewFeedBackCommentsUpsertInputModel candidateInterviewFeedBackCommentsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateInterviewFeedbackCommentsSearchOutputModel> GetCandidateInterviewFeedBackComments(CandidateInterviewFeedbackCommentsSearchInputModel candidateInterviewFeedbackCommentsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<JobOpeningsSearchOutputModel> GetCandidateJobOpenings(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateHistorySearchOutputModel> GetCandidateHistory(CandidateHistorySearchInputModel candidateHistorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void CandidateInterviewScheduleEmail(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CandidateInterviewScheduleSearchOutputModel CancelInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void CancelCandidateInterviewScheduleEmail(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateInterviewScheduleSearchOutputModel> GetScheduleAssigneeDetails(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void AssigneeInterviewScheduleApprovalEmail(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isRescheduled);
        List<CandidateInterviewScheduleSearchOutputModel> GetUserCandidateInterviewSchedules(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? HiredDocumentsList(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CandidateSkillsSearchOutputModel> GetSkillsByCandidates(CandidateSkillsSearchInputModel candidateSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void ReccurInterviewSchedule();
    }
}
