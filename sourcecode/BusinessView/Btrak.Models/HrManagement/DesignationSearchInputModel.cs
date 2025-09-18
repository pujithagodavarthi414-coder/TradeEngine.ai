using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class DesignationSearchInputModel : InputModelBase
    {
        public DesignationSearchInputModel() : base(InputTypeGuidConstants.DesignationSearchInputCommandTypeGuid)
        {
        }

        public Guid? DesignationId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DesignationId = " + DesignationId);
            stringBuilder.Append(", SearchText   = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
