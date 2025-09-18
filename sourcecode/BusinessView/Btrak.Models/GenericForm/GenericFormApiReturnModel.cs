using Btrak.Models.FormDataServices;
using System;
using System.Text;

namespace Btrak.Models.GenericForm
{
    public class GenericFormApiReturnModel
    {
        public Guid Id { get; set; }
        public Guid OriginalId { get; set; }
        public Guid? FormTypeId { get; set; }
        public Guid? DataSourceId { get; set; }
        public string FormTypeName { get; set; }

        public string Type { get; set; }
        public string FormName { get; set; }
        public string WorkflowTrigger { get; set; }
        public string FormJson { get; set; }
        public string FormBgColor { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public DateTime ArchivedDateTime { get; set; }
        public Guid ArchivedByUserId { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public string RoleIds { get; set; }
        public bool? IsAbleToLogin { get; set; }
        public bool? IsAbleToPay { get; set; }
        public bool? IsAbleToCall { get; set; }
        public bool? IsAbleToComment { get; set; }
        public string PayRoles { get; set; }
        public string CallRoles { get; set; }
        public string CommentRoles { get; set; }
        public Guid[] RoleForPay { get; set; }
        public Guid[] RoleForCall { get; set; }
        public Guid[] RoleForComment { get; set; }
        public string CustomApplications { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public dynamic Fields { get; set; }
        public Guid[] ViewFormRoleIds { get; set; }
        public Guid[] EditFormRoleIds { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", OriginalId = " + OriginalId);
            stringBuilder.Append(", FormTypeId = " + FormTypeId);
            stringBuilder.Append(", FormTypeName = " + FormTypeName);
            stringBuilder.Append(", FormName = " + FormName);
            stringBuilder.Append(", WorkflowTrigger = " + WorkflowTrigger); 
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", ArchivedByUserId = " + ArchivedByUserId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", IsAbleToLogin = " + IsAbleToLogin);
            stringBuilder.Append(", IsAbleToPay = " + IsAbleToPay);
            stringBuilder.Append(", IsAbleToCall = " + IsAbleToCall);
            stringBuilder.Append(", IsAbleToComment = " + IsAbleToComment);
            stringBuilder.Append(", CustomApplications = " + CustomApplications);
            return stringBuilder.ToString();
        }
    }

    public class DataSourceOutputModel
    {
        public Guid? Id { get; set; }
        public Guid Key { get; set; }
        public Guid? FormTypeId { get; set; }
        public string Description { get; set; }
        public string Name { get; set; }
        public string FormBgColor { get; set; }
        public string DataSourceType { get; set; }
        public string Tags { get; set; }
        public object Fields { get; set; }
        public dynamic FieldObject { get; set; }
        public bool IsArchived { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? DataSetId { get; set; }
        public DataSetConversionModel DataSetFormJson { get; set; }
        public Guid[] ViewFormRoleIds { get; set; }
        public Guid[] EditFormRoleIds { get; set; }
        public string Type { get; set; }
    }

    public class UserCompanyModel
    {
        public Guid? UserId { get; set; }
        public Guid? CompanyId { get; set; }
    }
}
