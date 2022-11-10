
from typing import List

import fastapi as _fastapi

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
    dist = KF1.predict([func.convert_rssi(post.RSSI1,post.RSSI2,post.RSSI3,post.RSSI4)])
    print(dist)
    result = _schemas.PostCreate1(position_x= 5.0,position_y= 5.0)
    
    db_user = _services.get_user_by_deviceID(db=db, deviceID=deviceID)
    if db_user is None:
        raise _fastapi.HTTPException(
            status_code=404, detail="sorry this user does not exist"
        )
    _services.create_post(db=db, post= post, deviceID=deviceID)
    
    return _services.create_post1(db=db, post= result, deviceID=deviceID)


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




if __name__=="__main__":
    
    uvicorn.run("main:app", host="127.0.0.1", log_level="info")