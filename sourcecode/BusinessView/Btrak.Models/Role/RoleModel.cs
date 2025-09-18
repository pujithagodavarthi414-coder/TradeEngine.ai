using System;

namespace Btrak.Models.Role
{
    public class FeatureModel
    {
        public Guid Id { get; set; }
        public string FeatureName { get; set; }
        public bool? IsActive { get; set; }
    }
}
