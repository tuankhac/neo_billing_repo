<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.File"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.commons.fileupload.FileItemStream"%>
<%@page import="org.apache.commons.fileupload.FileItemIterator"%>
<%@ page import="org.apache.commons.fileupload.util.Streams"%>
<%@page import="java.util.HashMap"%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="neo.velocity.common.Utility"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>

<%!int sumRow = 0;
	long mySEQ = 0;
	int batchSize = 10000;

	Utility u = new Utility();
	SimpleDateFormat dateParse = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat datetimeParse = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	PreparedStatement ps = null;
	Statement stm = null;
	Connection conn = null;
	
	String rootFolder = "";
	String uploadData = "/file_upload/";%>
<%
	rootFolder = getServletContext().getRealPath("/") + "promo_upload";
	System.out.println(rootFolder);
	int MAX_MEMORY_SIZE = 1024 * 1024 * 60; //60MB
	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	String result = "";

	HashMap<String, String> mParams = new HashMap<String, String>();
	if (isMultipart) {
		// Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(MAX_MEMORY_SIZE);
		// Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setHeaderEncoding("UTF-8");
		try {
			// Parse the request
			FileItemIterator iter = upload.getItemIterator(request);
			while (iter.hasNext()) {
				FileItemStream item = iter.next();
				String keyName = item.getFieldName();
				InputStream stream = item.openStream();
				if (item.isFormField()) {
					if (!mParams.containsKey(keyName)) {
						mParams.put(keyName, Streams.asString(stream));
					}
				} else {
					//ghi 1 file
					String fileName = getEnStringFromVnString(item.getName()).replaceAll(" +", "");
					String orgFileName = fileName.substring(0, fileName.lastIndexOf("."));
					String extFileName = fileName.substring(orgFileName.length()).toLowerCase();
					String resultWriteFile = ghiFile(stream, fileName);
					if (resultWriteFile.length() > 0) {
						//if("1".equals(insertData(rootFolder + uploadData + resultWriteFile,mParams)))
						//	result = "{RESULT:'OK',VALUE:'1'}";
						System.out.println(rootFolder + uploadData + resultWriteFile);
						result =insertData(rootFolder + uploadData + resultWriteFile,mParams);
					} else {
						result = "{RESULT:'FAIL',VALUE:'${n.i18n.writeFileError}'}";
					}
				}
			}
		} catch (Exception e) {
			result = "{RESULT:'FAIL',VALUE:'" + e.getMessage() + "'}";
		}
	}
	out.print(result);
%>
<%!public String insertData(String fileName, HashMap<String, String> mParams) {
		String result = "";
		String sql = "";
		String sqlSEQ = "select `auto_increment` from information_schema.tables where table_schema = 'billing' and table_name = 'promo_upload_temp'";
		long mySEQ = 0;
		try {
			conn = u.getConnection("crud");
			
			stm = conn.createStatement();
			ResultSet rs = stm.executeQuery(sqlSEQ);
			if (rs.next())
				mySEQ = rs.getLong(1);
			rs.close();
			
			sql ="insert into billing.promo_upload_temp(PROMO_ID, STB, COMPANY_ID,UPLOAD_ID, USER, IP) values (?,?,?,"+mySEQ+",'"+ mParams.get("user") +"','"+ mParams.get("user_ip") +"')";
			conn.setAutoCommit(false);
			ps = conn.prepareStatement(sql);
			result = readCSV(fileName, mySEQ);
		} catch (Exception e) {
			result = "{RESULT:'FAIL',VALUE:'" + e.getMessage()+"'}";
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (stm != null) {
					stm.close();
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}

	public String readCSV(String path,long mySEQ) {
		String result = "";
		BufferedReader br = null;
		String line = "";
		String cvsSplitBy = ",";
		int count = 0;
		try {
			br = new BufferedReader(new FileReader(path));
			while ((line = br.readLine()) != null) {
				// use comma as separator
				String[] records = line.split(cvsSplitBy);
				count ++;
				updateDB(records);
			}
			ps.executeBatch();
			ps.clearBatch();
			conn.commit();
			result = "{RESULT:'OK',VALUE:'"+mySEQ+"',SUM:'"+count+"'}";
		} catch (SQLException e) {
			result = "{RESULT:'FAIL',VALUE:'" + e.getMessage() + "'}";
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			result = "{RESULT:'FAIL',VALUE:'" + e.getMessage() + "'}";
		} catch (IOException e) {
			e.printStackTrace();
			result = "{RESULT:'FAIL',VALUE:'" + e.getMessage() + "'}";
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
		}
		return result;
	}

	private void updateDB(String[] list) {
		if (conn == null) {
			System.out.println("Connect fail");
			return;
		}
		try {
			for (int i = 0; i < 3; i++) {
				ps.setString(i + 1, list[i]);
			}
			ps.addBatch();

			ps.clearParameters();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public String getCurrentTime() {
		Calendar cal = Calendar.getInstance();
		String format = "_yyyyMMddHHmmss";
		DateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format(cal.getTime());
	}

	public String doiTenFile(String fileName) {
		fileName = fileName.replaceAll(" ", "");
		String orgFileName = fileName.substring(0, fileName.lastIndexOf("."));
		String extFileName = fileName.substring(orgFileName.length()).toLowerCase();
		fileName = orgFileName;
		File f = null;
		int j = 0;
		while (true) {
			f = new File(fileName + "/" + fileName + extFileName);
			if (f.exists())
				fileName = orgFileName + "" + j;
			else
				break;
			j++;
		}
		return fileName += extFileName;
	}

	private String ghiFile(InputStream in, String fileName) {
		String result = "";
		File fileUploaded = null;
		String path = "";
		try {
			String orgFileName = fileName.substring(0, fileName.lastIndexOf("."));
			String extFileName = fileName.substring(orgFileName.length()).toLowerCase();
			String finalFileName = orgFileName + getCurrentTime() + extFileName;
			path = rootFolder + uploadData + finalFileName;
			int j = 0;
			while (true) {
				fileUploaded = new File(path);
				if (fileUploaded.exists())
					finalFileName = orgFileName + getCurrentTime() + "_" + j + extFileName;
				else
					break;
				j++;
			}
			fileUploaded = new File(path);
			OutputStream out = new FileOutputStream(fileUploaded);
			byte[] buf = new byte[1024];
			int len;
			while ((len = in.read(buf)) > 0) {
				out.write(buf, 0, len);
			}
			if (fileUploaded.exists())
				//ghi file thanh cong, tra ve ten file
				result = finalFileName;
			out.close();
			in.close();
		} catch (Exception e) {
			result = "{RESULT:'FAIL',VALUE:'" + e.getMessage() + "'}";
		}
		return result;
	}

	public String vn_lower = "à,á,ả,ã,ạ,â,ầ,ấ,ẩ,ẫ,ậ,ă,ằ,ắ,ẳ,ẵ,f,è,é,ẻ,ẽ,ẹ,ê,ề,ế,ể,ễ,ệ,ì,í,ỉ,ĩ,ị,ò,ó,ỏ,õ,ọ,ô,ồ,ố,ổ,ỗ,ộ,ơ,ờ,ớ,ở,ỡ,ợ,ù,ú,ủ,ũ,ụ,ư,ừ,ứ,ử,ữ,ự,ỳ,ý,ỷ,ỹ,ỵ,đ";
	String vn_upper = "À,Á,Ả,Ã,Ạ,Â,Ầ,Ấ,Ẩ,Ẫ,Ậ,Ă,Ằ,Ắ,Ẳ,Ẵ,Ặ,È,É,Ẻ,Ẽ,Ẹ,Ê,Ề,Ế,Ể,Ễ,Ệ,Ì,Í,Ỉ,Ĩ,Ị,Ò,Ó,Ỏ,Õ,Ọ,Ô,Ồ,Ố,Ổ,Ỗ,Ộ,Ơ,Ờ,Ớ,Ở,Ỡ,Ợ,Ù,Ú,Ủ,Ũ,Ụ,Ư,Ừ,Ứ,Ử,Ữ,Ự,Ỳ,Ý,Ỷ,Ỹ,Ỵ,Đ";
	String en_lower = "a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,e,e,e,e,e,e,e,e,e,e,e,i,i,i,i,i,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,u,u,u,u,u,u,u,u,u,u,u,y,y,y,y,y,d";
	String en_upper = "A,A,A,A,A,A,A,A,A,A,A,A,A,A,A,A,A,E,E,E,E,E,E,E,E,E,E,E,I,I,I,I,I,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,U,U,U,U,U,U,U,U,U,U,U,Y,Y,Y,Y,Y,D";

	String vn_char_lower = vn_lower.replaceAll(",", "");
	String vn_char_upper = vn_upper.replaceAll(",", "");
	String en_char_lower = en_lower.replaceAll(",", "");
	String en_char_upper = en_upper.replaceAll(",", "");
	String character_iso_8859_1_map = "&quot;,&apos;,&amp;,&lt;,&gt;,&nbsp;,&iexcl;,&cent;,&pound;,&curren;,&yen;,&brvbar;,&sect;,&uml;,&copy;,&ordf;,&laquo;,&not;,&shy;,&reg;,&macr;,&deg;,&plusmn;,&sup2;,&sup3;,&acute;,&micro;,&para;,&middot;,&cedil;,&sup1;,&ordm;,&raquo;,&frac14;,&frac12;,&frac34;,&iquest;,&times;,&divide;,&Agrave;,&Aacute;,&Acirc;,&Atilde;,&Auml;,&Aring;,&AElig;,&Ccedil;,&Egrave;,&Eacute;,&Ecirc;,&Euml;,&Igrave;,&Iacute;,&Icirc;,&Iuml;,&ETH;,&Ntilde;,&Ograve;,&Oacute;,&Ocirc;,&Otilde;,&Ouml;,&Oslash;,&Ugrave;,&Uacute;,&Ucirc;,&Uuml;,&Yacute;,&THORN;,&szlig;,&agrave;,&aacute;,&acirc;,&atilde;,&auml;,&aring;,&aelig;,&ccedil;,&egrave;,&eacute;,&ecirc;,&euml;,&igrave;,&iacute;,&icirc;,&iuml;,&eth;,&ntilde;,&ograve;,&oacute;,&ocirc;,&otilde;,&ouml;,&oslash;,&ugrave;,&uacute;,&ucirc;,&uuml;,&yacute;,&thorn;,&yuml;";
	String[] character_iso_8859_1_map_arr = character_iso_8859_1_map.split(",");
	String character_unicode = "\",',&,<,>, ,¡,¢,£,¤,¥,¦,§,¨,©,ª,«,¬,�­,®,¯,°,±,²,³,´,µ,¶,·,¸,¹,º,»,¼,½,¾,¿,×,÷,À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,Ø,Ù,Ú,Û,Ü,Ý,Þ,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,ø,ù,ú,û,ü,ý,þ,ÿ";
	String[] character_unicode_arr = character_unicode.split(",");

	public String getEnStringFromVnString(String vnUtf8String) {
		if (vnUtf8String == null)
			return "";
		if (vnUtf8String.length() == 0)
			return "";

		String a = "";
		String s = ClearISO_8859_1_From_UTF8String(vnUtf8String);

		char b;
		for (int i = 0; i < s.length(); i++) {
			b = s.charAt(i);
			for (int j = 0; j < vn_char_lower.length(); j++) {
				if (b == vn_char_lower.charAt(j)) {
					b = en_char_lower.charAt(j);
					break;
				} else if (b == vn_char_upper.charAt(j)) {
					b = en_char_upper.charAt(j);
					break;
				}
			}

			a = a + Character.toString(b);
		}
		return a;
	}

	public String ClearISO_8859_1_From_UTF8String(String s) {
		try {
			if (s == null)
				return "";
			if (s.length() == 0)
				return "";

			String result = s;

			for (int i = 0; i < character_iso_8859_1_map_arr.length; i++) {
				String s1 = character_iso_8859_1_map_arr[i];
				// replace iso 8859_1 string by unicode string
				result = result.replaceAll(s1, character_unicode_arr[i]);
			}

			return result;
		} catch (Exception ex) {
			ex.printStackTrace();
			return "";
		}
	}%>