using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityReportInputModel
    {
        public List<Guid> UserId { get; set; }
        public bool? IsApp { get; set; }
        public bool? IsProductiveApps { get; set; }
        public bool? IsForCategories { get; set; }
        public DateTime? OnDate { get; set; }
        public bool MySelf { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(", IsProductiveApps" + IsProductiveApps);
            stringBuilder.Append(", IsApp" + IsApp);
            stringBuilder.Append(", OnDate" + OnDate);
            stringBuilder.Append(", MySelf" + MySelf);
            return stringBuilder.ToString();
        }
    }
}
