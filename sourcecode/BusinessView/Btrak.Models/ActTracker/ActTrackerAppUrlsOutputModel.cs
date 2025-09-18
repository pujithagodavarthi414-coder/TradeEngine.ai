using System;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerAppUrlsOutputModel
    {
        public Guid? AppUrlNameId { get; set; }
        public string AppUrlName { get; set; }
        public Guid? AppUrlTypeId { get; set; }
        public bool? IsApp { get; set; }
        public bool? IsProductive { get; set; }
        public string AppUrlImage { get; set; }
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public bool? IsArchive { get; set; }
        public string ProductiveRoleIds { get; set; }
        public string UnproductiveRoleIds { get; set; }
        public string ProductiveRoleNames { get; set; }
        public string UnproductiveRoleNames { get; set; }
    }
}