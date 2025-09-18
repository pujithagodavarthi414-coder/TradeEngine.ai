using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerAppUrlsSearchInputModel : SearchCriteriaInputModelBase
    {
        public ActTrackerAppUrlsSearchInputModel() : base(InputTypeGuidConstants.ActTrackerAppUrlsSearchInputCommandTypeGuid)
        {
        }

        public Guid? AppUrlsId { get; set; }
        public bool? IsProductive { get; set; }
        public Guid? CompanyIdFromTracker { get; set; }
        public Guid? ApplicationCategoryId { get; set; }
        public string ApplicationCategoryName { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AppUrlsId = " + AppUrlsId);
            stringBuilder.Append(", IsProductive = " + IsProductive);
            return stringBuilder.ToString();
        }
    }
}
