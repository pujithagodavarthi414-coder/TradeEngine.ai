using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.HrManagement
{
    public class BadgeModel : InputModelBase
    {
        public BadgeModel() : base(InputTypeGuidConstants.BadgeInputCommandTypeGuid)
        {
        }

        public Guid? BadgeId { get; set; }
        public string BadgeName { get; set; }
        public string Description { get; set; }
        public string SearchText { get; set; }
        public string ImageUrl { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BadgeId = " + BadgeId);
            stringBuilder.Append(", BadgeName = " + BadgeName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", ImageUrl = " + ImageUrl);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
