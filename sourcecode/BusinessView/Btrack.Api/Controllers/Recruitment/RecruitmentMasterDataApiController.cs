using Btrak.Models;
using Btrak.Models.Recruitment;
using Btrak.Models.User;
using Btrak.Services.Recruitment;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.Recruitment
{
    public class RecruitmentMasterDataApiController : AuthTokenApiController
    {
        private readonly IRecruitmentMasterDataService _recruitmentMasterDataService;
        public RecruitmentMasterDataApiController(IRecruitmentMasterDataService recruitmentMasterDataService)
        {
            _recruitmentMasterDataService = recruitmentMasterDataService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetJobOpeningStatus)]
        public JsonResult<BtrakJsonResult> GetJobOpeningStatus(JobOpeningStatusSearchInputModel jobOpeningStatusSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetJobOpeningStatus", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<JobOpeningStatusSearchOutputModel> jobOpeningStatus = _recruitmentMasterDataService.GetJobOpeningStatus(jobOpeningStatusSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetJobOpeningStatus", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetJobOpeningStatus", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = jobOpeningStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetJobOpeningStatus, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertJobOpeningStatus)]
        public JsonResult<BtrakJsonResult> UpsertJobOpeningStatus(JobOpeningStatusUpsertInputModel jobOpeningStatusUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertJobOpeningStatus", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobOpeningStatusId = _recruitmentMasterDataService.UpsertJobOpeningStatus(jobOpeningStatusUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertJobOpeningStatus", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertJobOpeningStatus", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = jobOpeningStatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertJobOpeningStatus, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetJobTypes)]
        public JsonResult<BtrakJsonResult> GetJobTypes(JobTypesSearchInputModel jobTypesSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetJobTypes", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<JobTypeSearchOutputModel> jobOpeningStatus = _recruitmentMasterDataService.GetJobTypes(jobTypesSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetJobTypes", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetJobTypes", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = jobOpeningStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetJobOpeningStatus, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertJobType)]
        public JsonResult<BtrakJsonResult> UpsertJobType(JobTypeUpsertInputModel jobTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertJobType", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobTypeId = _recruitmentMasterDataService.UpsertJobType(jobTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertJobType", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertJobType", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = jobTypeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertJobOpeningStatus, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSources)]
        public JsonResult<BtrakJsonResult> GetSources(SourceSearchInputModel SourceSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSources", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SourceSearchOutputModel> Source = _recruitmentMasterDataService.GetSources(SourceSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSources", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSources", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = Source, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetSource, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSource)]
        public JsonResult<BtrakJsonResult> UpsertSource(SourceUpsertInputModel SourceUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSource", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? SourceId = _recruitmentMasterDataService.UpsertSource(SourceUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSource", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSource", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = SourceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertSource, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDocumentType)]
        public JsonResult<BtrakJsonResult> UpsertDocumentType(DocumentTypeUpsertInputModel documentTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDocumentType", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? candidateDocumentTypeId = _recruitmentMasterDataService.UpsertDocumentType(documentTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDocumentType", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDocumentType", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateDocumentTypeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertDocumentType, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDocumentTypes)]
        public JsonResult<BtrakJsonResult> GetDocumentTypes(DocumentTypesSearchInputModel documentTypesSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDocumentTypes", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<DocumentTypesSearchOutputModel> candidateDocumentTypes = _recruitmentMasterDataService.GetDocumentTypes(documentTypesSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDocumentTypes", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDocumentTypes", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = candidateDocumentTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetDocumentTypes, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertInterviewType)]
        public JsonResult<BtrakJsonResult> UpsertInterviewType(InterviewTypeUpsertInputModel interviewTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewType", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? interviewTypeId = _recruitmentMasterDataService.UpsertInterviewType(interviewTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewType", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewType", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = interviewTypeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertInterviewType, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInterviewTypes)]
        public JsonResult<BtrakJsonResult> GetInterviewTypes(InterviewTypesSearchInputModel interviewTypesSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewTypes", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<InterviewTypesSearchOutputModel> interviewTypes = _recruitmentMasterDataService.GetInterviewTypes(interviewTypesSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewTypes", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewTypes", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = interviewTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetInterviewTypes, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertHiringStatus)]
        public JsonResult<BtrakJsonResult> UpsertHiringStatus(HiringStatusUpsertInputModel hiringStatusUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertHiringStatus", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? hiringsStatusId = _recruitmentMasterDataService.UpsertHiringStatus(hiringStatusUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertHiringStatus", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertHiringStatus", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = hiringsStatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertHiringStatus, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetHiringStatus)]
        public JsonResult<BtrakJsonResult> GetHiringStatus(HiringStatusSearchInputModel hiringStatusSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHiringStatus", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<HiringStatusSearchOutputModel> hiringStatus = _recruitmentMasterDataService.GetHiringStatus(hiringStatusSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHiringStatus", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHiringStatus", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = hiringStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetHiringStatus, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertInterviewRating)]
        public JsonResult<BtrakJsonResult> UpsertInterviewRating(InterviewRatingUpsertInputModel interviewRatingUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInterviewRating", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? interviewRatingId = _recruitmentMasterDataService.UpsertInterviewRating(interviewRatingUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewRating", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInterviewRating", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = interviewRatingId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertInterviewRating, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInterviewRatings)]
        public JsonResult<BtrakJsonResult> GetInterviewRatings(InterviewRatingSearchInputModel interviewRatingSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInterviewRatings", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<InterviewRatingSearchOutputModel> interviewRatings = _recruitmentMasterDataService.GetInterviewRatings(interviewRatingSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewRatings", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInterviewRatings", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = interviewRatings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetInterviewRatings, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetScheduleStatus)]
        public JsonResult<BtrakJsonResult> GetScheduleStatus(ScheduleStatusSearchInputModel scheduleStatusSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetScheduleStatus", "Recruitment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ScheduleStatusSearchOutputModel> ScheduleStatus = _recruitmentMasterDataService.GetScheduleStatus(scheduleStatusSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetScheduleStatus", "Recruitment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetScheduleStatus", "Recruitment Api"));

                return Json(new BtrakJsonResult { Data = ScheduleStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetScheduleStatus, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetCandidateRegistrationDropDown)]
        public JsonResult<BtrakJsonResult> GetCandidateRegistrationDropDown(CandidateRegistrationDropDownInputModel candidateRegistrationDropDownInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCandidateRegistrationDropDown", "Recruitment MasterData Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                object data = _recruitmentMasterDataService.GetCandidateRegistrationDropDown(candidateRegistrationDropDownInputModel.JobOpeningId, candidateRegistrationDropDownInputModel.Type, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateRegistrationDropDown", "Recruitment MasterData Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCandidateRegistrationDropDown", "Recruitment MasterData Api"));

                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetScheduleStatus, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}