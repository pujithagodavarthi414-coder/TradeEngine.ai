using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class DepartmentUpsertInputModel : InputModelBase
    {
        public DepartmentUpsertInputModel() : base(InputTypeGuidConstants.DepartmentUpsertInputCommandTypeGuid)
        {
        }

        public Guid? DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DepartmentId = " + DepartmentId);
            stringBuilder.Append(", DepartmentName = " + DepartmentName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}

