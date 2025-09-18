using Btrak.Services.Projects;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Models;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using BTrak.Api.Helpers;
using BTrak.Common;
using Btrak.Models.ProjectType;

namespace BTrak.Api.Controllers.Projects
{
    public class ProjectTypesApiController : AuthTokenApiController
    {
        private readonly IProjectTypeService _projectTypeService;

        public ProjectTypesApiController(IProjectTypeService projectTypeService)
        {
            _projectTypeService = projectTypeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProjectType)]
        public JsonResult<BtrakJsonResult> UpsertProjectType(ProjectTypeUpsertInputModel projectTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProjectType", "ProjectTypes Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? projectTypeIdReturned = _projectTypeService.UpsertProjectType(projectTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProjectType", "ProjectTypes Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProjectType", "ProjectTypes Api"));

                return Json(new BtrakJsonResult { Data = projectTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectType", "ProjectTypesApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllProjectTypes)]
        public JsonResult<BtrakJsonResult> GetAllProjectTypes(ProjectTypeInputModel projectTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllProjectTypes", "ProjectTypes Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ProjectTypeApiReturnModel> projectTypes = _projectTypeService.GetAllProjectTypes(projectTypeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllProjectTypes", "ProjectTypes Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllProjectTypes", "ProjectTypes Api"));

                return Json(new BtrakJsonResult { Data = projectTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProjectTypes", "ProjectTypesApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProjectTypeById)]
        public JsonResult<BtrakJsonResult> GetProjectTypeById(Guid? projectTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProjectTypeById", "ProjectTypes Api"));

                var validationMessages = new List<ValidationMessage>();

                ProjectTypeApiReturnModel projectTypeDetails = _projectTypeService.GetProjectTypeById(projectTypeId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProjectTypeById", "ProjectTypes Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProjectTypeById", "ProjectTypes Api"));

                return Json(new BtrakJsonResult { Data = projectTypeDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectTypeById", "ProjectTypesApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
