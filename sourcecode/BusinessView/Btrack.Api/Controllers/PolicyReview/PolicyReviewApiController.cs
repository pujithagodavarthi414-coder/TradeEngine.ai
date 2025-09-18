using Btrak.Api.Controllers.Api;
using Btrak.Api.Helpers;
using Btrak.Api.Models;
using Btrak.Models.PolicyReview;
using Btrak.Services.PolicyReview;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.PolicyReview
{
    public class PolicyReviewApiController : AuthTokenApiController
    {
        private readonly IPolicyReviewService _policyReviewService;

        public PolicyReviewApiController()
        {
            _policyReviewService = new PolicyReviewService();
        }


        [HttpPost]
        [HttpOptions]
        [Route("PolicyReview/PolicyReviewApi/AddOrUpdateNewPolicy")]
        public JsonResult<BtrakJsonResult> AddOrUpdateNewPolicy([FromBody]CreateNewPolicyModel createNewPolicyModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Or Update New Policy", "Policy Review Api"));

                if (ModelState.IsValid)
                {
                    _policyReviewService.AddOrUpdateNewPolicy(createNewPolicyModel, LoggedInContext);

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Or Update New Policy", "Policy Review Api"));
                    return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Or Update New Policy", "Policy Review Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add Or Update New Policy", "Policy Review Api", exception.Message));
                throw;
            }
        }



        [HttpGet]
        [HttpOptions]
        [Route("PolicyReview/PolicyReviewApi/GetPolicyCategoryValues")]
        public IList<PolicyCategorySelectionModel> GetPolicyCategoryValues(Guid id)
        {           
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get PolicyCategoryValues", "Policy Review Api"));
                return _policyReviewService.GetPolicyCategoryValues(id);                       
        }

        [HttpGet]
        [HttpOptions]
        [Route("PolicyReview/PolicyReviewApi/GetPolicyUserValues")]
        public IList<PolicyUserSelectionModel> GetPolicyUserValues(Guid id)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get PolicyUserValues", "Policy Review Api"));
            return _policyReviewService.GetPolicyUserValues(id);
        }

        [HttpGet]
        [HttpOptions]
        [Route("PolicyReview/PolicyReviewApi/GetPolicyDetailsToTheTable")]
        public CreateNewPolicyModel GetPolicyDetailsToTheTable()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Policy Details To The Table", "Policy Review Api"));
            return _policyReviewService.GetPolicyDetailsToTheTable();
        }
    }
}