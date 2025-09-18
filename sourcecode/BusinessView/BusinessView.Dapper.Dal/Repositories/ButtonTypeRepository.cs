using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ButtonTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ButtonType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ButtonTypeDbEntity aButtonType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aButtonType.Id);
					 vParams.Add("@ButtonTypeName",aButtonType.ButtonTypeName);
					 vParams.Add("@CompanyId",aButtonType.CompanyId);
					 vParams.Add("@CreatedDateTime",aButtonType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aButtonType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aButtonType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aButtonType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ButtonTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ButtonType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ButtonTypeDbEntity aButtonType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aButtonType.Id);
					 vParams.Add("@ButtonTypeName",aButtonType.ButtonTypeName);
					 vParams.Add("@CompanyId",aButtonType.CompanyId);
					 vParams.Add("@CreatedDateTime",aButtonType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aButtonType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aButtonType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aButtonType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ButtonTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

     

        /// <summary>
        /// Selects the Single object of ButtonType table.
        /// </summary>
        public ButtonTypeDbEntity GetButtonType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ButtonTypeDbEntity>("USP_ButtonTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ButtonType table.
		/// </summary>
		 public IEnumerable<ButtonTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ButtonTypeDbEntity>("USP_ButtonTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

       

        /// <summary>
        /// Selects all records from the ButtonType table by a foreign key.
        /// </summary>
        public List<ButtonTypeDbEntity> SelectAllByCompanyId(Guid companyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CompanyId",companyId);
				 return vConn.Query<ButtonTypeDbEntity>("USP_ButtonTypeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

      

        /// <summary>
        /// Selects all records from the ButtonType table by a foreign key.
        /// </summary>
        public List<ButtonTypeDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<ButtonTypeDbEntity>("USP_ButtonTypeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
