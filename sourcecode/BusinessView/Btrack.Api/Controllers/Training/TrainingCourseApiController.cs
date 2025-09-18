using Btrak.Models;
using Btrak.Models.Training;
using Btrak.Services.Training;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.Training
{
    public class TrainingCourseApiController : AuthTokenApiController
    {
        private readonly ITrainingCourseService _trainingCourseService;

        public TrainingCourseApiController(ITrainingCourseService trainingCourseService)
        {
            _trainingCourseService = trainingCourseService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTrainingCourses)]
        public JsonResult<BtrakJsonResult> SearchTrainingCourses(TrainingCourseSearchModel trainingCourseSearchModel)
        {
            try
            {
                BtrakJsonResult btrakJsonResult;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search Training Courses", "Training Course Api"));

                if (trainingCourseSearchModel == null)
                {
                    trainingCourseSearchModel = new TrainingCourseSearchModel();
                }

                var validationMessages = new List<ValidationMessage>();

                List<TrainingCourse> trainingCourses = _trainingCourseService.SearchTrainingCourses(trainingCourseSearchModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Training Courses", "Training Course Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Training Courses", "Training Course Api"));

                return Json(new BtrakJsonResult { Data = trainingCourses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTrainingCourses ", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTrainingCourseService)]
        public JsonResult<BtrakJsonResult> UpsertTrainingCourse(TrainingCourse trainingCourse)
        {
            try
            {
                BtrakJsonResult btrakJsonResult;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTrainingCourse", "Training Course Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? expenseIdReturned = _trainingCourseService.UpsertTrainingCourse(trainingCourse, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTrainingCourse", "Training Course Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTrainingCourse", "Training Course Api"));

                return Json(new BtrakJsonResult { Data = expenseIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTrainingCourse ", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ArchiveOrUnArchiveTrainingCourse)]
        public JsonResult<BtrakJsonResult> ArchiveOrUnArchiveTrainingCourse(TrainingCourse trainingCourse)
        {
            try
            {
                BtrakJsonResult btrakJsonResult;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveTrainingCourse", "Training Course Api"));

                var validationMessages = new List<ValidationMessage>();

                var result = _trainingCourseService.ArchiveOrUnArchiveTrainingCourse(trainingCourse, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveTrainingCourse", "Training Course Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveTrainingCourse", "Training Course Api"));

                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveOrUnArchiveTrainingCourse ", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTrainingCourses)]
        public JsonResult<BtrakJsonResult> GetTrainingCourses()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTrainingCourses", "Training Course Api"));

                var validationMessages = new List<ValidationMessage>();

                var trainingCourses = _trainingCourseService.GetTrainingCourses(LoggedInContext, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTrainingCourses", "Training Course Api"));

                return Json(new BtrakJsonResult { Data = trainingCourses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrainingCourses ", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTrainingAssignments)]
        public JsonResult<BtrakJsonResult> SearchTrainingAssignments(TrainingAssignmentSearchModel trainingAssignmentSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTrainingAssignments", "Training Course Api"));

                var validationMessages = new List<ValidationMessage>();

                List<TrainingAssignmentOutPutModel> trainingAssignments = _trainingCourseService.SearchTrainingAssignments(trainingAssignmentSearchModel, LoggedInContext, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTrainingAssignments", "Training Course Api"));

                return Json(new BtrakJsonResult { Data = trainingAssignments, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTrainingAssignments ", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.AssignOrUnAssignTrainingCourse)]
        public JsonResult<BtrakJsonResult> AssignOrUnAssignTrainingCourse(AssignmentsInputModel assignments)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AssignTrainingCourses", "Training Course Api"));

                var validationMessages = new List<ValidationMessage>();

                _trainingCourseService.AssignOrUnAssignTrainingCourse(assignments, LoggedInContext, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AssignTrainingCourses", "Training Course Api"));

                return Json(new BtrakJsonResult { Data = true, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AssignOrUnAssignTrainingCourse ", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.AddOrUpdateAssignmentStatus)]
        public JsonResult<BtrakJsonResult> AddOrUpdateAssignmentStatus(TrainingAssignment assignment)
        {
            try
            {
                var headers = Request.Headers;
                var AuthorisedUser = Request.Properties["loggedin-user"] as ValidUserOutputmodel;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddOrUpdateAssignmentStatus", "Training Course Api"));

                var validationMessages = new List<ValidationMessage>();

                _trainingCourseService.AddOrUpdateAssignmentStatus(assignment, LoggedInContext, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddOrUpdateAssignmentStatus", "Training Course Api"));

                return Json(new BtrakJsonResult { Data = true, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddOrUpdateAssignmentStatus ", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAssignmentStatuses)]
        public JsonResult<BtrakJsonResult> GetAssignmentStatuses()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAssignmentStatuses", "Training Course Api"));

                var validationMessages = new List<ValidationMessage>();

                List<AssignmentStatus> assignmentStatuses = _trainingCourseService.GetAssignmentStatuses(LoggedInContext, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAssignmentStatuses", "Training Course Api"));

                return Json(new BtrakJsonResult { Data = assignmentStatuses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssignmentStatuses ", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAssignmentWorkflow)]
        public JsonResult<BtrakJsonResult> GetAssignmentWorkflow([FromUri]Guid assignmentId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAssignmentWorkflow", "Training Course Api"));

                var validationMessages = new List<ValidationMessage>();

                List<TrainingWorkflow> assignmentWorkflow = _trainingCourseService.GetAssignmentWorkflow(assignmentId, LoggedInContext, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAssignmentWorkflow", "Training Course Api"));

                return Json(new BtrakJsonResult { Data = assignmentWorkflow, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssignmentWorkflow", " TrainingCourseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
