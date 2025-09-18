using Btrak.Models;
using Btrak.Models.RepositoryCommits;
using Btrak.Services.RepositoryCommits;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.RepositoryCommits
{
    public class RepositoryCommitsApiController : AuthTokenApiController
    {
        private readonly IRepositoryCommitsService _repositoryCommitService;

        public RepositoryCommitsApiController(IRepositoryCommitsService repositoryCommitService)
        {
            _repositoryCommitService = repositoryCommitService;
        }

        [HttpPost]
        [AllowAnonymous]
        [HttpOptions]
        [Route(RouteConstants.UpsertGitLabCommits)]
        public JsonResult<BtrakJsonResult> UpsertGitLabCommits(GitLabCommitInputModel gitLabCommitInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGitLabCommits", "RepositoryCommitsApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                bool jobDone = _repositoryCommitService.UpsertGitlabCommits(gitLabCommitInput, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGitLabCommits", "RepositoryCommitsApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGitLabCommits", "RepositoryCommitsApiController"));
                return Json(new BtrakJsonResult { Data = jobDone, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGitLabCommits", "RepositoryCommitsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [AllowAnonymous]
        [HttpOptions]
        [Route(RouteConstants.UpsertBitBucketCommits)]
        public JsonResult<BtrakJsonResult> UpsertBitBucketCommits(BitBucketCommitInputModel bitBucketCommitInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBitBucketCommits", "RepositoryCommitsApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                bool jobDone = _repositoryCommitService.UpsertBitBucketCommits(bitBucketCommitInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBitBucketCommits", "RepositoryCommitsApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBitBucketCommits", "RepositoryCommitsApiController"));
                return Json(new BtrakJsonResult { Data = jobDone, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBitBucketCommits", "RepositoryCommitsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchRepositoryCommits)]
        public JsonResult<BtrakJsonResult> SearchRepositoryCommits(RepositoryCommitsSearchModel repositoryCommitsSearch)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchRepositoryCommits", "RepositoryCommitsApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<RepositoryCommitsModel> commits = _repositoryCommitService.SearchRepositoryCommits(repositoryCommitsSearch, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchRepositoryCommits", "RepositoryCommitsApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchRepositoryCommits", "RepositoryCommitsApiController"));
                return Json(new BtrakJsonResult { Data = commits, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchRepositoryCommits", "RepositoryCommitsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}