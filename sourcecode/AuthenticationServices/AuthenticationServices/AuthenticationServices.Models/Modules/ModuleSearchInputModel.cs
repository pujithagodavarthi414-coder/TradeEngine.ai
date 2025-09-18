using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
    public class ModuleSearchInputModel
    {
        public Guid? ModuleId { get; set; }
        public string SearchText { get; set; }
    }
}
