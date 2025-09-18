using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class DepartmentSearchInputModel : InputModelBase
    {
        public DepartmentSearchInputModel() : base(InputTypeGuidConstants.DepartmentSearchInputCommandTypeGuid)
        {
        }

        public Guid? DepartmentId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DepartmentId = " + DepartmentId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchive = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
