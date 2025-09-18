using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class UserStoryStatusReportInputModel
    {
        public Guid? GoalId { get; set; }
        public Guid? SprintId { get; set; }
        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string TimeZone { get; set; }
    }
}
