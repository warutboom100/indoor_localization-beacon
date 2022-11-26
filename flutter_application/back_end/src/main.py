
from cmath import sqrt
import math
from typing import List

import fastapi as _fastapi
import numpy as np

import sqlalchemy.orm as _orm
import uvicorn
import services as _services, schemas as _schemas
import xlsxwriter
import pandas as pd

import procress as func





KF1 = func.Kalmanfilter_dist(2.0,1.35,1.35,1.35,1.35)
KF2 = func.KalmanFilter1(2.0,0.5,0.5)

app = _fastapi.FastAPI()

_services.create_database()




@app.post("/reg_users", response_model=_schemas.User)
def create_user(
    user: _schemas.UserCreate, db: _orm.Session = _fastapi.Depends(_services.get_db)
):
    db_user = _services.get_user_by_deviceID(db=db, deviceID=user.deviceID)
    if db_user:
        raise _fastapi.HTTPException(
            status_code=400, detail="woops the Username is in use"
        )
    return _services.create_user(db=db, user=user)


@app.get("/users", response_model=List[_schemas.User])
def read_users(
    skip: int = 0,
    limit: int = 10,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    users = _services.get_users(db=db, skip=skip, limit=limit)
    return users


@app.get("/login_users/{user_id}", response_model=_schemas.User)
def read_user(user_id: str, db: _orm.Session = _fastapi.Depends(_services.get_db)):
    db_user = _services.get_user(db=db, user_id=user_id)
    if db_user is None:
        raise _fastapi.HTTPException(
            status_code=404, detail="sorry this user does not exist"
        )
    return db_user


@app.post("/Sent_rssi{deviceID}/posts", response_model=_schemas.Post1)
async def create_post(
    deviceID: str,
    post: _schemas.PostCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
    
):
    readDataframe = pd.read_excel (r'data/rssi-data1.xlsx')
    rssi = [post.RSSI1,post.RSSI2,post.RSSI3,post.RSSI4,post.RSSI5]
#     # print(np.exp(-9.2)*np.exp(-0.14339 * rssi[0]))
#     # dist = list(func.convert_rssi(post.RSSI1,post.RSSI2,post.RSSI3,post.RSSI4))
    print(len(readDataframe["RSSI1"]),rssi[3]) 
    if(len(readDataframe["RSSI1"])>602):
      print('end')
    else:
      
      newDataframe = pd.DataFrame({'Mac-address' : ['rrsi_2.828'],'RSSI1' : [rssi[3]]})
   
      frames = [readDataframe, newDataframe]
      result = pd.concat(frames)
   # สร้าง Writer เหมือนกับตอนเขียนไฟล์
      writer = pd.ExcelWriter('data/rssi-data1.xlsx', engine='xlsxwriter')
   # นำข้อมูลชุดใหม่เขียนลงไฟล์และจบการทำงาน
      result.to_excel(writer, index = False)
      writer.save()
    
    # a = func.convert_rssi_curvefit(rssi)
    # mean = _services.get_meanrssi(db=db,deviceID=deviceID)
    # std = _services.get_stdrssi(db=db,deviceID=deviceID)

    


    
    # if(mean[0] != None):
        
        
    #     if(std[0][0] == 10000.0) :
            
    #         _services.create_rssi(db=db, post= _schemas.rssicreate(rssi1=rssi[0],rssi2=rssi[1],rssi3=rssi[2],rssi4=rssi[3],rssi5=rssi[4])
    #         ,  deviceID=deviceID)
    #     # else:
    #         _services.create_dist(db=db, post= _schemas.distcreate(dist1=a[0],dist2=a[1],dist3=a[2],dist4=a[3],
    #     dist5=0.0), deviceID=deviceID)

    #         pos = func.trilateration([a[0],a[1],a[2],a[3]])

    #         _services.create_pos(db=db, post= _schemas.poscreate(x=pos[0],y=pos[1]), deviceID=deviceID)
        
    #     elif(std[0][0]  != 10000.0) :

    #         a1 = func.gaussian(mean[0][0],std[0][0],rssi[0])
    #         a2 = func.gaussian(mean[1][0],std[1][0],rssi[1])
    #         a3 = func.gaussian(mean[2][0],std[2][0],rssi[2])
    #         a4 = func.gaussian(mean[3][0],std[3][0],rssi[3])
    #         G_ = [a1,a2,a3,a4]
    #         # print(rssi)
    #         # print(a1,a2,a3,a4)
    #         data = [0.0, 0.0, 0.0, 0.0]
            
    #         for i in range(len(G_)):
    #             if(0.6 <= G_[i] <= 1):
    #                 data[i] = rssi[i]
    #             else:
    #                 if rssi[i] > mean[i][0]:
    #                     data[i] = sqrt(2*std[i][0]*np.log(3.8*std[i][0])).real + mean[i][0]
    #                 elif rssi[i] < mean[i][0]:
    #                     data[i] = (sqrt(2*std[i][0]*np.log(6.3*std[i][0])).real - mean[i][0])*-1

            

    #         _services.create_rssi(db=db, post= _schemas.rssicreate(rssi1=data[0],rssi2=data[1],rssi3=data[2],rssi4=data[3],rssi5=0.0)
    #         ,   deviceID=deviceID)
             
            

    #         b = func.convert_rssi_curvefit(data)

            
    #         pos = func.trilateration([b[0],b[1],b[2],b[3]])
            
            

    #         _services.create_dist(db=db, post= _schemas.distcreate(dist1=b[0],dist2=b[1],dist3=b[2],
    #         dist4=b[3], dist5=0.0), deviceID=deviceID)
    #         _services.create_pos(db=db, post= _schemas.poscreate(x=pos[0],y=pos[1]), deviceID=deviceID)
        

    # # #         population_df1 = np.random.normal(mean[0],std[0],31)
    # # #         population_df2 = np.random.normal(mean[1],std[1],31)
    # # #         population_df3 = np.random.normal(mean[2],std[2],31)
    # # #         population_df4 = np.random.normal(mean[3],std[3],31)

    # # #         a1 = func.gaussian(mean[0],std[0],dist[0])
    # # #         a2 = func.gaussian(mean[1],std[1],dist[1])
    # # #         a3 = func.gaussian(mean[2],std[2],dist[2])
    # # #         a4 = func.gaussian(mean[3],std[3],dist[3])

    # # #         print('a1 = '+str(a1))
    # # #         sample_b = [func.random_sampling(population_df1, 31) ,func.random_sampling(population_df2, 31), 
    # # #         func.random_sampling(population_df3, 31) ,func.random_sampling(population_df4, 31)]
    # # #         b = [0.0,0.0,0.0,0.0]
    # # #         b1 =[0.0,0.0,0.0,0.0]
    # # #         for i in range(len(sample_b)):
                
    # # #             for j in sample_b[i]:
    # # #                 # print(func.gaussian(mean[i],std[i],j).real)
    # # #                 if(func.gaussian(mean[i],std[i],j).real >= b[i]):
    # # #                     b[i]= j
                        
    # # #                     b1[i] = func.gaussian(mean[i],std[i],j).real
            
            
            
    # #     # mean = _services.get_meandist(db=db,deviceID=deviceID)
    # #     # std = _services.get_stddist(db=db,deviceID=deviceID)
    # #     # _services.create_weightdist(db=db, post=_schemas.weightdistance_create(mean_dist1=mean[0],std_dist1=std[0],
    # #     # mean_dist2=mean[1],std_dist2=std[1],mean_dist3=mean[2],std_dist3=std[2],mean_dist4=mean[3],std_dist4=std[3],
    # #     # mean_dist5=mean[4],std_dist5=std[4]),deviceID=deviceID)

    # elif(mean[0] == None):
        
    #     _services.create_rssi(db=db, post= _schemas.rssicreate(rssi1=rssi[0],rssi2=rssi[1],rssi3=rssi[2],rssi4=rssi[3],rssi5=rssi[4])
    # ,   deviceID=deviceID)

    #     _services.create_dist(db=db, post= _schemas.distcreate(dist1=a[0],dist2=a[1],dist3=a[2],dist4=a[3],
    #         dist5=0.0), deviceID=deviceID)

    #     pos = func.trilateration([a[0],a[1],a[2],a[3]])

    #     _services.create_pos(db=db, post= _schemas.poscreate(x=pos[0],y=pos[1]), deviceID=deviceID)
        



    #     _services.create_weightrssi(db=db, post=_schemas.weightrssi_create(mean_rssi1=0.0,std_rssi1=10000.0,
    #     mean_rssi2=0.0,std_rssi2=10000.0,mean_rssi3=0.0,std_rssi3=10000.0,mean_rssi4=0.0,std_rssi4=10000.0,
    #     mean_rssi5=0.0,std_rssi5=10000.0),deviceID=deviceID)

    #     _services.create_weightdist(db=db, post=_schemas.weightdist_create(mean_dist1=0.0,std_dist1=10000.0,
    #     mean_dist2=0.0,std_dist2=10000.0,mean_dist3=0.0,std_dist3=10000.0,mean_dist4=0.0,std_dist4=10000.0,
    #     mean_dist5=0.0,std_dist5=10000.0),deviceID=deviceID)
    # print(func.trilateration(dist))
    # result = _schemas.PostCreate1(position_x= 5.23,position_y= 2.56)
    
    db_user = _services.get_user_by_deviceID(db=db, deviceID=deviceID)
    if db_user is None:
        raise _fastapi.HTTPException(
            status_code=404, detail="sorry this user does not exist"
        )

    _services.create_post(db=db, post= post, deviceID=deviceID)
    # _services.create_postdist(db=db, post= _schemas.Postdistcreate(DIST1=a[0],DIST2=a[1],DIST3=a[2],DIST4=a[3],
    #     DIST5=0.0), deviceID=deviceID)
    return 
    
@app.get("/read_position{deviceID}", response_model=_schemas.Post1)
async def read_posts(
    deviceID: str,
    
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):

    mean_rssi = _services.get_meanrssi1(db=db,deviceID=deviceID)
    std_rssi = _services.get_stdrssi1(db=db,deviceID=deviceID)
    
    mean_dist = _services.get_meandist1(db=db,deviceID=deviceID)
    std_dist = _services.get_stddist1(db=db,deviceID=deviceID)

    _services.create_weightrssi(db=db, post=_schemas.weightrssi_create(mean_rssi1=mean_rssi[0],std_rssi1=std_rssi[0],
        mean_rssi2=mean_rssi[1],std_rssi2=std_rssi[1],mean_rssi3=mean_rssi[2],std_rssi3=std_rssi[2],mean_rssi4=mean_rssi[3],
        std_rssi4=std_rssi[3], mean_rssi5=mean_rssi[4],std_rssi5=std_rssi[4]),deviceID=deviceID)

    _services.create_weightdist(db=db, post=_schemas.weightdist_create(mean_dist1=mean_dist[0],std_dist1=std_dist[0],
        mean_dist2=mean_dist[1],std_dist2=std_dist[1],mean_dist3=mean_dist[2],std_dist3=std_dist[2],mean_dist4=mean_dist[3],
        std_dist4=std_dist[3], mean_dist5=mean_dist[4],std_dist5=std_dist[4]),deviceID=deviceID)

    
    mean_dist = _services.get_meandist2(db=db,deviceID=deviceID)
    std_dist = _services.get_stddist2(db=db,deviceID=deviceID)

    std_pos = _services.get_stdpos(db=db,deviceID=deviceID)
    dist1 = [mean_dist[0],mean_dist[1],mean_dist[2],mean_dist[3]]
    std1 = [std_dist[0],std_dist[1],std_dist[2],std_dist[3]]
    

    trigulation = func.trilateration_weight(dist1,std1,std_pos)
    print(trigulation)
    trigulation1 = func.trilateration(dist1)
    print(trigulation1)
    # post = _schemas.PostCreate1(position_x= np.squeeze(np.asarray(ans))[0][0],position_y= np.squeeze(np.asarray(ans))[0][1])
    post = _schemas.PostCreate1(position_x= 2.5,position_y= 3.5)
    result = _services.create_post1(db=db, post= post, deviceID=deviceID)
    _services.delete_post(db=db, deviceID=deviceID)
    _services.delete_dist(db=db, deviceID=deviceID)
    _services.delete_rssi(db=db, deviceID=deviceID)
    _services.delete_Postdist(db=db, deviceID=deviceID)
    _services.delete_pos(db=db, deviceID=deviceID)
    return  result


@app.get("/gets_position{deviceID}", response_model=List[_schemas.Post1])
def read_posts(
    deviceID: str,
    skip: int = 0,
    limit: int = 10,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    posts = _services.get_posts(db=db, skip=skip, limit=limit, deviceID=deviceID)
    
    return posts


@app.get("/posts{post_id}", response_model=_schemas.Post)
def read_post(post_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)):
    post = _services.get_post(db=db, post_id=post_id)
    if post is None:
        raise _fastapi.HTTPException(
            status_code=404, detail="sorry this post does not exist"
        )

    return post


@app.delete("/posts{post_id}")
def delete_post(post_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)):
    _services.delete_post(db=db, post_id=post_id)
    return {"message": f"successfully deleted post with id: {post_id}"}


@app.put("/posts{post_id}", response_model=_schemas.Post)
def update_post(
    post_id: int,
    post: _schemas.PostCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return _services.update_post(db=db, post=post, post_id=post_id)




