using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.LeaveManagement
{
    public class DeleteLeavePermissionModel : InputModelBase
    {
        public DeleteLeavePermissionModel() : base(InputTypeGuidConstants.DeletePermissionModelInputCommandTypeGuid)
        {
        }
        public Guid? PermissionId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PermissionId = " + PermissionId);
            return stringBuilder.ToString();
        }
    }
}
