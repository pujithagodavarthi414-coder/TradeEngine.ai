using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class AccessisbleIpAdresseRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the AccessisbleIpAdresses table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(AccessisbleIpAdresseDbEntity aAccessisbleIpAdresse)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aAccessisbleIpAdresse.Id);
					 vParams.Add("@CompanyId",aAccessisbleIpAdresse.CompanyId);
					 vParams.Add("@Name",aAccessisbleIpAdresse.Name);
					 vParams.Add("@IpAddress",aAccessisbleIpAdresse.IpAddress);
					 vParams.Add("@CreatedDateTime",aAccessisbleIpAdresse.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aAccessisbleIpAdresse.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aAccessisbleIpAdresse.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aAccessisbleIpAdresse.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_AccessisbleIpAdressesInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the AccessisbleIpAdresses table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(AccessisbleIpAdresseDbEntity aAccessisbleIpAdresse)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aAccessisbleIpAdresse.Id);
					 vParams.Add("@CompanyId",aAccessisbleIpAdresse.CompanyId);
					 vParams.Add("@Name",aAccessisbleIpAdresse.Name);
					 vParams.Add("@IpAddress",aAccessisbleIpAdresse.IpAddress);
					 vParams.Add("@CreatedDateTime",aAccessisbleIpAdresse.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aAccessisbleIpAdresse.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aAccessisbleIpAdresse.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aAccessisbleIpAdresse.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_AccessisbleIpAdressesUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of AccessisbleIpAdresses table.
		/// </summary>
		public AccessisbleIpAdresseDbEntity GetAccessisbleIpAdresse(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<AccessisbleIpAdresseDbEntity>("USP_AccessisbleIpAdressesSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the AccessisbleIpAdresses table.
		/// </summary>
		 public IEnumerable<AccessisbleIpAdresseDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<AccessisbleIpAdresseDbEntity>("USP_AccessisbleIpAdressesSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
