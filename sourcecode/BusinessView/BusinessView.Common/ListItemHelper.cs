using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace BTrak.Common
{
    public class ListItemHelper
    {
        public List<SelectListItem> GetIsEmptyAssetsDropDown()
        {
            var data = new[]{
                new SelectListItem{ Value="All",Text="All"},
                new SelectListItem{ Value="Empty",Text="Empty"},
                new SelectListItem{ Value="Filled",Text="Filled"}
            };
            var getEmptyAssetsList = data.ToList();
            return getEmptyAssetsList;
        }

        //public List<SelectListItem> GetTeamLeads()
        //{
        //    var list = new List<SelectListItem>
        //    {
        //        new SelectListItem
        //        {
        //            Text = "Please select user",
        //            Value = "0"
        //        }
        //    };

        //    list.AddRange(_userService.GetUsers(3).Where(x => x.IsActive).Select(x => new SelectListItem
        //    {
        //        Text = x.FullName,
        //        Value = x.Id.ToString(),
        //    }).ToList());

        //    return list;
        //}

        //public List<SelectListItem> GetManagers()
        //{
        //    var list = new List<SelectListItem>
        //    {
        //        new SelectListItem
        //        {
        //            Text = "Please select user",
        //            Value = "0"
        //        }
        //    };

        //    list.AddRange(_userService.GetUsers(2).Where(x => x.IsActive).Select(x => new SelectListItem
        //    {
        //        Text = x.FullName,
        //        Value = x.Id.ToString(),
        //    }).ToList());

        //    return list;
        //}

        //public List<SelectListItem> GetUsersMultiSelectList()
        //{
        //    var result = _userService.GetUsers(1);

        //    var list = new List<SelectListItem>();

        //    if (result.Count > 0)
        //    {
        //        list.AddRange(result.Select(x => new SelectListItem
        //        {
        //            Text = x.UserName + " " + x.SurName,
        //            Value = x.Id.ToString(),
        //        }));
        //    }

        //    return list;
        //}
    }
}
