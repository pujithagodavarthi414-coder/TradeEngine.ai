using BTrak.Common;

namespace Btrak.Models
{
    public class UserSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public UserSearchCriteriaInputModel() : base(InputTypeGuidConstants.UserSearchCriteriaInputCommandTypeGuid)
        {
        }

        public string Email { get; set; }
        public string RoleName { get; set; }
        public string BranchName { get; set; }
    }
}
