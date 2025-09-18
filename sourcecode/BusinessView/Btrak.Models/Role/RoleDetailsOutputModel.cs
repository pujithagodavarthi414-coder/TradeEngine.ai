using System;

namespace Btrak.Models.Role
{
    public class RoleDetailsOutputModel
    {
        public Guid Id { get; set; }
        public string RoleName { get; set; }
        public bool? IsDeveloper { get; set; }
        public bool? IsAdministrator { get; set; }
        public bool? IsHidden { get; set; }
    }
}
