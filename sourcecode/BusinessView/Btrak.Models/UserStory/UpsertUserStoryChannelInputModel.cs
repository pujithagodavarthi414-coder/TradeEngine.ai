using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class UpsertUserStoryChannelInputModel : InputModelBase
    {
        public UpsertUserStoryChannelInputModel() : base(InputTypeGuidConstants.UserStoryChannelInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? ProjectMemberId { get; set; }
        public bool? IsArchived { get; set; }
    }
}
