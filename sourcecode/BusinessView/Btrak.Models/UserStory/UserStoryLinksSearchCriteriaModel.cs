using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class UserStoryLinksSearchCriteriaModel : SearchCriteriaInputModelBase
    {
        public UserStoryLinksSearchCriteriaModel() : base(InputTypeGuidConstants.UserStorySearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserStoryId { get; set; }
        public Guid? UserStoryLinkId { get; set; } 
        public bool? IsSprintUserStories { get; set; }
    }
}
