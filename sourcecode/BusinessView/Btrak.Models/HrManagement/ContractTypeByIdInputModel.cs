using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    class ContractTypeByIdInputModel : InputModelBase
    {
        public ContractTypeByIdInputModel() : base(InputTypeGuidConstants.DepartmentSearchInputCommandTypeGuid)
        {
        }

        public Guid? contractTypeId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DepartmentId = " + contractTypeId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchive = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}