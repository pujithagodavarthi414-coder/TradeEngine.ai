using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class DesignationUpsertInputModel : InputModelBase
    {
        public DesignationUpsertInputModel() : base(InputTypeGuidConstants.DesignationUpsertInputCommandTypeGuid)
        {
        }

        public Guid? DesignationId { get; set; }
        public string DesignationName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DesignationId = " + DesignationId);
            stringBuilder.Append(", DesignationName = " + DesignationName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
