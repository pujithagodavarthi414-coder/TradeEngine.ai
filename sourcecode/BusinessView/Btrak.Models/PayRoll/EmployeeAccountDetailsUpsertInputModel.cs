using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeAccountDetailsUpsertInputModel: InputModelBase
    {
        public EmployeeAccountDetailsUpsertInputModel() : base(InputTypeGuidConstants.EmployeeAccountDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeAccountDetailsId { get; set; }
        public string PFNumber { get; set; }
        public string UANNumber { get; set; }
        public string ESINumber { get; set; }
        public string PANNumber { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? EmployeeId { get; set; }

    public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeAccountDetailsId = " + EmployeeAccountDetailsId);
            stringBuilder.Append(",PFNumber = " + PFNumber);
            stringBuilder.Append(",ESINumber = " + ESINumber);
            stringBuilder.Append(",PANNumber = " + PANNumber);
            stringBuilder.Append(",UANNumber = " + UANNumber);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
