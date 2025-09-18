using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace Btrak.Models
{
    [XmlRoot("Roles")]
    public class Roles
    {
        [XmlElement("Role")]
        public List<RolesModel> Role { get; set; }
    }

    public class PermissionConfigurationModel
    {
        public Guid PermissionConfigurationId { get; set; }
        public string Permission { get; set; }
    }
}

