using System;

namespace Btrak.Models.Role
{
    public class RoleFeatureApiReturnModel
    {
        public Guid? RoleFeatureId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? RoledId { get; set; }
        public Guid? FeatureId { get; set; }
        public Guid? ParentFeatureId { get; set; }
        public string RoleName { get; set; }
        public string FeatureName { get; set; }
        public string ParentFeatureName { get; set; }
        public int TotalCount { get; set; }
        public DateTime? RoleFeaturesCreatedDateTime { get; set; }
        public Guid? RoleFeaturesCreatedByUserId { get; set; }
        public Guid? RoleFeaturesUpdatedByUserId { get; set; }
        public Guid? RoleCreatedByUserId { get; set; }
        public Guid? RoleUpdatedByUserId { get; set; }
        public DateTime? RoleUpdatedDateTime { get; set; }
        public bool? FeatureIsActive { get; set; }
        public Guid? FeatureCreatedByUserId { get; set; }
        public DateTime? FeatureCreatedDateTime { get; set; }
        public Guid? FeatureUpdatedByUserId { get; set; }
        public DateTime? FeatureUpdatedDateTime { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? RoleFeaturesUpdatedDateTime { get; set; }
        public DateTime? RoleCreatedDateTime { get; set; }
    }
}
                          
