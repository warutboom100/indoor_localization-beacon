
from cmath import sqrt
import math
from typing import List

import fastapi as _fastapi
import numpy as np

import sqlalchemy.orm as _orm
import uvicorn
import services as _services, schemas as _schemas


import procress as func





KF1 = func.Kalmanfilter_dist(1.0,0.85,1.25,1.25,1.25)

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
def create_post(
    deviceID: str,
    post: _schemas.PostCreate,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
    
):
    rssi = [post.RSSI1,post.RSSI2,post.RSSI3,post.RSSI4,post.RSSI5]
    # dist = list(func.convert_rssi(post.RSSI1,post.RSSI2,post.RSSI3,post.RSSI4))

    mean = _services.get_meandist(db=db,deviceID=deviceID)
    std = _services.get_stddist(db=db,deviceID=deviceID)
    # print(mean)
    # print(std)

    
    if(mean[0] != None):
        if(std[0][0] and std[1][0] and std[2][0] and std[3][0] == 10000.0) :
            _services.create_dist(db=db, post= _schemas.Distcreate(dist1=rssi[0],dist2=rssi[1],dist3=rssi[2],dist4=rssi[3],dist5=rssi[4])
    ,   deviceID=deviceID)
        # else:
            
            

        elif(std[0][0] and std[1][0] and std[2][0] and std[3][0] != 10000.0) :
            a1 = func.gaussian(mean[0][0],std[0][0],rssi[0])
            a2 = func.gaussian(mean[1][0],std[1][0],rssi[1])
            a3 = func.gaussian(mean[2][0],std[2][0],rssi[2])
            a4 = func.gaussian(mean[3][0],std[3][0],rssi[3])
            G_ = [a1,a2,a3,a4]
            # print(rssi)
            # print(a1,a2,a3,a4)
            data = [0.0, 0.0, 0.0, 0.0, 0.0]
            print(G_)
            for i in range(len(G_)):
                if(0.6 <= G_[i] <= 1):
                    data[i] = rssi[i]
                else:
                    if rssi[i] > mean[i][0]:
                        data[i] = sqrt(2*std[i][0]*np.log(3.8*std[i][0])).real + mean[i][0]
                    elif rssi[i] < mean[i][0]:
                        data[i] = (sqrt(2*std[i][0]*np.log(6.3*std[i][0])).real - mean[i][0])*-1
            _services.create_dist(db=db, post= _schemas.Distcreate(dist1=data[0],dist2=data[1],dist3=data[2],dist4=data[3],dist5=data[4])
                , deviceID=deviceID)
            print(data)
        

    #         population_df1 = np.random.normal(mean[0],std[0],31)
    #         population_df2 = np.random.normal(mean[1],std[1],31)
    #         population_df3 = np.random.normal(mean[2],std[2],31)
    #         population_df4 = np.random.normal(mean[3],std[3],31)

    #         a1 = func.gaussian(mean[0],std[0],dist[0])
    #         a2 = func.gaussian(mean[1],std[1],dist[1])
    #         a3 = func.gaussian(mean[2],std[2],dist[2])
    #         a4 = func.gaussian(mean[3],std[3],dist[3])

    #         print('a1 = '+str(a1))
    #         sample_b = [func.random_sampling(population_df1, 31) ,func.random_sampling(population_df2, 31), 
    #         func.random_sampling(population_df3, 31) ,func.random_sampling(population_df4, 31)]
    #         b = [0.0,0.0,0.0,0.0]
    #         b1 =[0.0,0.0,0.0,0.0]
    #         for i in range(len(sample_b)):
                
    #             for j in sample_b[i]:
    #                 # print(func.gaussian(mean[i],std[i],j).real)
    #                 if(func.gaussian(mean[i],std[i],j).real >= b[i]):
    #                     b[i]= j
                        
    #                     b1[i] = func.gaussian(mean[i],std[i],j).real
            
            
            
    #     mean = _services.get_meandist(db=db,deviceID=deviceID)
    #     std = _services.get_stddist(db=db,deviceID=deviceID)
    #     _services.create_weightdist(db=db, post=_schemas.weightdistance_create(mean_dist1=mean[0],std_dist1=std[0],
    #     mean_dist2=mean[1],std_dist2=std[1],mean_dist3=mean[2],std_dist3=std[2],mean_dist4=mean[3],std_dist4=std[3],
    #     mean_dist5=mean[4],std_dist5=std[4]),deviceID=deviceID)

    elif(mean[0] == None):

        _services.create_dist(db=db, post= _schemas.Distcreate(dist1=rssi[0],dist2=rssi[1],dist3=rssi[2],dist4=rssi[3],dist5=rssi[4])
    , deviceID=deviceID)

        _services.create_weightdist(db=db, post=_schemas.weightdistance_create(mean_dist1=0.0,std_dist1=10000.0,
        mean_dist2=0.0,std_dist2=10000.0,mean_dist3=0.0,std_dist3=10000.0,mean_dist4=0.0,std_dist4=10000.0,
        mean_dist5=0.0,std_dist5=10000.0),deviceID=deviceID)
    # print(func.trilateration(dist))
    result = _schemas.PostCreate1(position_x= 5.23,position_y= 2.56)
    
    db_user = _services.get_user_by_deviceID(db=db, deviceID=deviceID)
    if db_user is None:
        raise _fastapi.HTTPException(
            status_code=404, detail="sorry this user does not exist"
        )
    _services.create_post(db=db, post= post, deviceID=deviceID)
    
    # return _services.create_post1(db=db, post= result, deviceID=deviceID)
@app.get("/read_position{deviceID}", response_model=List[_schemas.Post1])
def read_posts(
    deviceID: str,
    
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    mean = _services.get_meandist1(db=db,deviceID=deviceID)
    std = _services.get_stddist1(db=db,deviceID=deviceID)
    _services.create_weightdist(db=db, post=_schemas.weightdistance_create(mean_dist1=mean[0],std_dist1=std[0],
        mean_dist2=mean[1],std_dist2=std[1],mean_dist3=mean[2],std_dist3=std[2],mean_dist4=mean[3],std_dist4=std[3],
        mean_dist5=mean[4],std_dist5=std[4]),deviceID=deviceID)
    mean = _services.get_meandist1(db=db,deviceID=deviceID)
    std = _services.get_stddist1(db=db,deviceID=deviceID)
    print(mean)
    print(std)
    _services.delete_post(db=db, deviceID=deviceID)
    return 

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




