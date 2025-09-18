using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Xml.Serialization;

namespace Btrak.Models
{
    public class RolesModel
    {
        public RolesModel()
        {
            RolesPermissions = new List<RolesPermissionsModel>();
        }

        [XmlElement("RoleId")]
        public Guid RoleId
        {
            get;
            set;
        }

        [Required(ErrorMessage = "Please Enter Role")]
        public string RoleName
        {
            get;
            set;
        }

        public int? Order
        {
            get;
            set;
        }

        public Guid[] FeatureIds
        {
            get;
            set;
        }

        public List<RolesPermissionsModel> RolesPermissions
        {
            get;
            set;
        }
    }

    public class PermissionsModel
    {
        public Guid? FeatureId
        {
            get;
            set;
        }

        public string FeatureName
        {
            get;
            set;
        }

        public bool IsFeatureAccessible
        {
            get;
            set;
        }

        public bool IsShow
        {
            get;
            set;
        }

        public bool IsProjectResponsiblePerson
        {
            get;
            set;
        }
    }

    public class RolesPermissionsModel
    {
        public RolesPermissionsModel()
        {
            Permissions = new List<PermissionsModel>();
        }

        public List<PermissionsModel> Permissions
        {
            get;
            set;
        }

        public Guid? MainFeatureId
        {
            get;
            set;
        }

        public string MainFeatureName
        {
            get;
            set;
        }

        public Guid? RoleId
        {
            get;
            set;
        }

        public string RoleName
        {
            get;
            set;
        }
    }
}
