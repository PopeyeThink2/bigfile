package com.xia.bigfile.utils;

import java.sql.*;

/**
 * JDBC工具类
 *
 * */
public class JDBCUtil {
    private static Connection connection;
    //远程访问mysql数据库权限用户的用户名和密码
    private  static String username = "root";//用户名通常为root
    private  static String password = "123456";//密码通常空
    private static PreparedStatement ps;

    /**1.
     * 获取jdbc连接的方法getconnection （通过JDBCUtil.getConnection（）来获取一个JDBC的连接）
     * ip 为数据库所在的远程服务器的ip地址
     * port 为数据库访问的端口
     * mysqldatabase  要连接的数据库名称
     * */
    public static Connection getConnection(){
        try {
            //1加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            //2.获取连jdbc连接  再由驱动管理者获取连接（url，username，password）
            String url = "jdbc:mysql://127.0.0.1:3306/uploadfile?serverTimezone=GMT%2B8&characterEncoding=utf-8&useSSL=false&rewriteBatchedStatements=true";
            return connection = DriverManager.getConnection(url, username, password);
        } catch (Exception e) {//捕捉所有的异常
            e.printStackTrace();
        }
        return null;
    }


    /**2.
     * 关闭，释放资源的方法close （若不存在使用下列资源，传递参数为null即可，通过JDBCUtil.close()关闭资源）
     * rs 为结果集，通过JDBC查到的结果集，使用后需关闭释放资源
     * stmt 为开启的sql语句
     * connection 为jdbc的连接
     * */
    public static void close(ResultSet rs, Statement stmt, Connection connection){//栈式关闭（最先连接，最后关闭连接）
        try{//关闭结果集
            if(rs!=null) rs.close();
        }catch (SQLException e){
            e.printStackTrace();
        }

        try{//关闭sql语句
            if(ps!=null) ps.close();
            if(stmt!=null) stmt.close();
        }catch (SQLException e){
            e.printStackTrace();
        }

        try{//关闭连接
            if(connection!=null) connection.close();
        }catch (SQLException e){
            e.printStackTrace();
        }

    }


}
