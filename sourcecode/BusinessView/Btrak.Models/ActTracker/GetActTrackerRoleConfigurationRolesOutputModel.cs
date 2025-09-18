using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActTracker
{
    public class GetActTrackerRoleConfigurationRolesOutputModel
    {
        public Guid? ActTrackerRoleConfigId { get; set; }
        public Guid? RoleId { get; set; }
        public bool ConsiderPunchCard { get; set; }
        public string RoleName { get; set; }
        public Guid? AppUrlId { get; set; }
        public string AppURL { get; set; }
        public int? FrequencyIndex { get; set; }
        public bool? SelectAll { get; set; }
    }

    public class ActTrackerRoleConfigurationRoles
    {
        public List<Guid?> ActTrackerRoleConfigId { get; set; }
        public List<Guid?> RoleId { get; set; }
        public bool ConsiderPunchCard { get; set; }
        public List<string> RoleName { get; set; }
        public Guid? AppUrlId { get; set; }
        public string AppURL { get; set; }
        public int? FrequencyIndex { get; set; }
        public bool? SelectAll { get; set; }
    }
    public class ActTrackerRoleConfiguration
    {
        public Guid? AppUrlId { get; set; }
        public bool ConsiderPunchCard { get; set; }
        public List<ActTrackerRoleConfigurationRoles> IndividualRoles { get; set; }
    }
}