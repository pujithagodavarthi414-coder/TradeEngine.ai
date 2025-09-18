using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class ProjectFeatureSpEntity
    {
        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }
        public Guid? ProjectId { get; set; }
        public bool IsDelete { get; set; }
        public Guid? ProjectFeatureResponsiblePersonId { get; set; }
        public string ProjectFeatureResponsiblePersonName { get; set; }

        public string ProfileImage { get; set; }
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
    }
}
