using Btrak.Models;
using Btrak.Models.Projects;
using Btrak.Services.Projects;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using BTrak.Api.Helpers;

namespace BTrak.Api.Controllers.Projects
{
    public class ProjectFeaturesApiController : AuthTokenApiController
    {
        private readonly IProjectFeatureService _projectFeatureService;

        public ProjectFeaturesApiController(IProjectFeatureService projectFeatureService)
        {
            _projectFeatureService = projectFeatureService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProjectFeature)]
        public JsonResult<BtrakJsonResult> UpsertProjectFeature(ProjectFeatureUpsertInputModel projectFeatureModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProjectFeature", "Project Features Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? projectFeatureIdReturned = _projectFeatureService.UpsertProjectFeature(projectFeatureModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProjectFeature", "Project Features Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProjectFeature", "Project Features Api"));
                return Json(new BtrakJsonResult { Data = projectFeatureIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectFeature", " ProjectFeaturesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllProjectFeaturesByProjectId)]
        public JsonResult<BtrakJsonResult> GetAllProjectFeaturesByProjectId(ProjectFeatureSearchCriteriaInputModel projectFeatureSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllProjectFeaturesByProjectId", "Project Features Api"));

                if (projectFeatureSearchCriteriaInputModel == null)
                {
                    projectFeatureSearchCriteriaInputModel = new ProjectFeatureSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ProjectFeatureApiReturnModel> projectFeatures = _projectFeatureService.GetAllProjectFeaturesByProjectId(projectFeatureSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllProjectFeaturesByProjectId", "Project Features Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllProjectFeaturesByProjectId", "Project Features Api"));
                return Json(new BtrakJsonResult { Data = projectFeatures, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProjectFeaturesByProjectId", " ProjectFeaturesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProjectFeatureById)]
        public JsonResult<BtrakJsonResult> GetProjectFeatureById(Guid? projectFeatureId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProjectFeatureById", "Project Features Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                ProjectFeatureApiReturnModel projectFeatureDetails = _projectFeatureService.GetProjectFeatureById(projectFeatureId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProjectFeatureById", "Project Features Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProjectFeatureById", "Project Features Api"));
                return Json(new BtrakJsonResult { Data = projectFeatureDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectFeatureById", " ProjectFeaturesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteProjectFeature)]
        public JsonResult<BtrakJsonResult> DeleteProjectFeature(DeleteProjectFeatureModel deleteProjectFeatureModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteProjectFeature", "deleteProjectFeatureModel", deleteProjectFeatureModel, "Project Feature Api"));
                BtrakJsonResult btrakJsonResult;
                Guid? returnGuid = _projectFeatureService.DeleteProjectFeature(deleteProjectFeatureModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Delete Project Feature is completed. Return Guid is " + returnGuid + ", source command is " + deleteProjectFeatureModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteProjectFeature", "Project Feature Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteProjectFeature", "Project Feature Api"));
                return Json(new BtrakJsonResult { Data = returnGuid, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteProjectFeature", " ProjectFeaturesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
