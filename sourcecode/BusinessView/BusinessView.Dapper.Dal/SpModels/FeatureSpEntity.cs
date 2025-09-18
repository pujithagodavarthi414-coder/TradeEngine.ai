using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class FeatureSpEntity
    {
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public Guid? FeatureId { get; set; }
        public string Feature { get; set; }
        public bool IsAccessible { get; set; }
        public bool IsShow { get; set; }
    }
}
