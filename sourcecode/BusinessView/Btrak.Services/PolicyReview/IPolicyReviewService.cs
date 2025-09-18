using Btrak.Models.PolicyReview;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.PolicyReview
{
    public interface IPolicyReviewService
    {
        void AddOrUpdateNewPolicy(CreateNewPolicyModel createNewPolicyModel,  LoggedInContext loggedInContext);
        IList<PolicyCategorySelectionModel> GetPolicyCategoryValues(Guid id);
        IList<PolicyUserSelectionModel> GetPolicyUserValues(Guid id);
        CreateNewPolicyModel GetPolicyDetailsToTheTable();
    }
}
