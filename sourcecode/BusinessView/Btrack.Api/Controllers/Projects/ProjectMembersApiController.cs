using Btrak.Services.Projects;
using BTrak.Api.Controllers.Api;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Projects;
using BTrak.Api.Helpers;
using BTrak.Api.Models;

namespace BTrak.Api.Controllers.Projects
{
    public class ProjectMembersApiController : AuthTokenApiController
    {
        private readonly IProjectMemberService _projectMemberService;

        public ProjectMembersApiController(IProjectMemberService projectMemberService)
        {
            _projectMemberService = projectMemberService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProjectMember)]
        public JsonResult<BtrakJsonResult> UpsertProjectMember(ProjectMemberUpsertInputModel projectMemberUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProjectMember", "Project Members Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<Guid> id = _projectMemberService.UpsertProjectMember(projectMemberUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProjectMember", "Project Members Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProjectMember", "Project Members Api"));

                return Json(new BtrakJsonResult { Data = id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectMember", "ProjectMembersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllProjectMembers)]
        public JsonResult<BtrakJsonResult> GetAllProjectMembers(ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllProjectMembers", "Project Members Api"));

                if (projectMemberSearchCriteriaInputModel == null)
                {
                    projectMemberSearchCriteriaInputModel = new ProjectMemberSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ProjectMemberApiReturnModel> projectMembers = _projectMemberService.GetAllProjectMembers(projectMemberSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllProjectMembers", "Project Members Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllProjectMembers", "Project Members Api"));

                return Json(new BtrakJsonResult { Data = projectMembers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProjectMembers", "ProjectMembersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProjectMemberById)]
        public JsonResult<BtrakJsonResult> GetProjectMemberById(Guid projectMemberId,Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProjectMemberById", "Project Members Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                ProjectMemberApiReturnModel projectMember = _projectMemberService.GetProjectMemberById(projectMemberId,projectId ,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProjectMemberByUserId", "Project Members Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProjectMemberByUserId", "Project Members Api"));

                return Json(new BtrakJsonResult { Data = projectMember, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectMemberById", "ProjectMembersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProjectAndChannelMember)]
        public JsonResult<BtrakJsonResult> UpsertProjectAndChannelMember(ProjectMemberUpsertInputModel projectMemberUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProjectAndChannel", "Projects Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                ProjectAndChannelApiReturnModel channelModel = _projectMemberService.UpsertProjectAndChannelMembers(null,projectMemberUpsertInputModel,LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProjectAndChannel", "Projects Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProjectAndChannel", "Projects Api"));
                return Json(new BtrakJsonResult { Data = channelModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectAndChannelMember", "ProjectMembersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteProjectMember)]
        public JsonResult<BtrakJsonResult> DeleteProjectMember(DeleteProjectMemberModel deleteProjectMemberModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteProjectMember", "companyInputModel", deleteProjectMemberModel, "Project Members Api"));
                BtrakJsonResult btrakJsonResult;
                DeleteProjectMemberOutputModel returnGuid = _projectMemberService.DeleteProjectMember(deleteProjectMemberModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Delete Project Member is completed. Return Guid is " + returnGuid + ", source command is " + deleteProjectMemberModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteProjectMember", "Project Members Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteProjectMember", "Project Members Api"));
                return Json(new BtrakJsonResult { Data = returnGuid, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteProjectMember", "ProjectMembersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}