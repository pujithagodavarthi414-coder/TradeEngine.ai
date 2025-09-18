using System;
using System.Collections.Generic;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerAppUrlApiOutputModel
    {
        public Guid? AppUrlNameId { get; set; }
        public string AppUrlName { get; set; }
        public Guid? AppUrlTypeId { get; set; }
        public bool? IsApp { get; set; }
        public bool? IsProductive { get; set; }
        public string ProductiveValue { get; set; }
        public string AppUrlImage { get; set; }
        public List<object> RoleIds { get; set; }
        public List<object> RoleNames { get; set; }
        public string Roles { get; set; }
        public bool? IsArchive { get; set; }
        public List<Guid> ProductiveRoleIds { get; set; }
        public List<Guid> UnproductiveRoleIds { get; set; }
        public string ProductiveRoles { get; set; }
        public string UnproductiveRoles { get; set; }
        public string ProductiveRoleNames { get; set; }
        public string UnproductiveRoleNames { get; set; }
        public Guid? ApplicationCategoryId { get; set; }
        public string ApplicationCategoryName { get; set; }
    }
}