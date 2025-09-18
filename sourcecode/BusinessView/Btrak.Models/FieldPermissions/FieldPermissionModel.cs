using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace Btrak.Models.FieldPermissions
{
    public class FieldPermissionModel
    {
        public FieldPermissionModel()
        {
            Configurations = new List<ConfigurationViewModel>();
            FieldPermissions = new List<FieldPermissionViewModel>();
        }

        public Guid ConfigurationId { get; set; }
        public string ConfigurationName { get; set; }

        public List<ConfigurationViewModel> Configurations { get; set; }
        public List<FieldPermissionViewModel> FieldPermissions { get; set; }
    }

    public class FieldPermissionViewModel
    {
        public Guid Id { get; set; }

        public Guid PermissionId { get; set; }
        public string PermissionName { get; set; }

        public Guid ConfigurationId { get; set; }
        public string ConfigurationName { get; set; }

        public Guid FieldId { get; set; }
        public string FieldName { get; set; }

        public string GoalStatus { get; set; }
        public string GoalStatusName { get; set; }
        public string[] GoalStatusGuids { get; set; }
        public List<string> SelectedGoalStatuses { get; set; }
        public IList<SelectListItem> GoalStatuses { get; set; }

        public string UserStoryStatus { get; set; }
        public string UserStoryStatusName { get; set; }
        public string[] UserStoryStatusGuids { get; set; }
        public List<string> SelectedUserStoryStatuses { get; set; }
        public IList<SelectListItem> UserStoryStatuses { get; set; }

        public string GoalType { get; set; }
        public string GoalTypeName { get; set; }
        public string[] GoalTypeGuids { get; set; }
        public List<string> SelectedGoalTypes { get; set; }
        public IList<SelectListItem> GoalTypes { get; set; }

        public string Role { get; set; }
        public string RoleName { get; set; }
        public string[] RoleGuids { get; set; }
        public List<string> SelectedRoles { get; set; }
        public IList<SelectListItem> Roles { get; set; }

        public bool IsMandatory { get; set; }

        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
    }

    public class ConfigurationViewModel
    {
        public Guid ConfigurationId { get; set; }

        [StringLength(500, ErrorMessage = "The ConfigurationName value cannot exceed 500 characters.")]
        [Required(ErrorMessage = "Please enter configuration name")]
        public string ConfigurationName { get; set; }

        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
    }
}
