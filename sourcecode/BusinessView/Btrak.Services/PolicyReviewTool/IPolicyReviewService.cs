using Btrak.Models.PolicyReviewTool;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Btrak.Dapper.Dal.Models;

namespace Btrak.Services.PolicyReviewTool
{
    public interface IPolicyReviewService
    {
        void AddOrUpdateNewPolicy(CreateNewPolicyModel createNewPolicyModel, LoggedInContext loggedInContext);

        List<PolicyDetailsToTable> GetPolicyDetailsToTheTable();

        List<PolicyCategoryDbEntity> GetAllPolicyCategoriesIdAndValue();

        List<PolicyUsersModel> GetAllPolicyUsersIdAndValue();

        Task<string> UploadFile(HttpPostedFileBase fileName);
    }
}
