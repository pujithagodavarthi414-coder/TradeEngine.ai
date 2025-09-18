using System;
using System.Collections.Generic;

namespace Btrak.Models.ConfigurationType
{
    public class ConfigurationSettingSpReturnModel
    {
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
    }
}
