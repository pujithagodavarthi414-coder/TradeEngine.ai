using System.Text;
using BTrak.Common;

namespace Btrak.Models.SystemManagement
{
    public class SystemRoleSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public SystemRoleSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchSystemRolesCommandId)
        {
        }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}