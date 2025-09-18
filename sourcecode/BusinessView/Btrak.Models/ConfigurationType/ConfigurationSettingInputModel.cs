using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ConfigurationType
{
    public class ConfigurationSettingInputModel : InputModelBase
    {
        public ConfigurationSettingInputModel() : base(InputTypeGuidConstants.ConfigurationSettingsInputCommandTypeGuid)
        {
        }

        public Guid? ConfigurationTypeId { get; set; }
        public Guid? FieldId { get; set; }
        public string FieldName { get; set; }
        public Guid? CrudOperationId { get; set; }
        public string OperationName { get; set; }
        public Guid? FieldPermissionId { get; set; }
        public List<Guid> GoalStatuses { get; set; }
        public List<Guid> UserStoryStatuses { get; set; }
        public List<Guid> GoalTypes { get; set; }
        public List<Guid> Roles { get; set; }
        public string GoalStatusIds { get; set; }
        public string UserStoryStatusIds { get; set; }
        public string GoalTypeIds { get; set; }
        public string RoleIds { get; set; }
        public string GoalStatusNames { get; set; }
        public string UserStoryStatusNames { get; set; }
        public string GoalTypeNames { get; set; }
        public string RoleNames { get; set; }
        public bool IsMandatory { get; set; }
        public string ConfigurationSettingXml { get; set; }

        public Guid? ProjectId { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ConfigurationTypeId = " + ConfigurationTypeId);
            stringBuilder.Append(", FieldId = " + FieldId);
            stringBuilder.Append(", FieldName = " + FieldName);
            stringBuilder.Append(", CrudOperationId = " + CrudOperationId);
            stringBuilder.Append(", OperationName = " + OperationName);
            stringBuilder.Append(", FieldPermissionId = " + FieldPermissionId);
            stringBuilder.Append(", GoalStatusIds = " + GoalStatusIds);
            stringBuilder.Append(", UserStoryStatusIds = " + UserStoryStatusIds);
            stringBuilder.Append(", GoalTypeIds = " + GoalTypeIds);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", GoalStatusNames = " + GoalStatusNames);
            stringBuilder.Append(", UserStoryStatusNames = " + UserStoryStatusNames);
            stringBuilder.Append(", GoalTypeNames = " + GoalTypeNames);
            stringBuilder.Append(", RoleNames = " + RoleNames);
            stringBuilder.Append(", IsMandatory = " + IsMandatory);
            stringBuilder.Append(", ConfigurationSettingXml = " + ConfigurationSettingXml);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
