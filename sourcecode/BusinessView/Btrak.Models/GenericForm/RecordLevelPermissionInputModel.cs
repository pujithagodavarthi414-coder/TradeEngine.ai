using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class RecordLevelPermissionInputModel
    {
        public string UserIds { get; set; }
        public string RoleIds { get; set; }
        public List<FieldPermissionModel> Fields { get; set; }
    }

    public class FieldPermissionModel
    {
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public string Condition { get; set; }

    }
    public class RecordPermissionMainModdel
    {
        public List<RecordLevelPermissionInputModel> ScenarioSteps { get; set;}
    }
    public class ScenarioModel
    {
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public string Stage { get; set; }
    }
}
