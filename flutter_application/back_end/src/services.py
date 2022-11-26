from typing import List

import sqlalchemy.orm as _orm
from models import User
import numpy as np
import models as _models, schemas as _schemas, database as _database




def create_database():
    return _database.Base.metadata.create_all(bind=_database.engine)


def get_db():
    db = _database.SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_user(db: _orm.Session, user_id: str):
    return db.query(_models.User).filter(_models.User.deviceID == user_id).first()


def get_user_by_deviceID(db: _orm.Session, deviceID: str):
    return db.query(_models.User).filter(_models.User.deviceID == deviceID).first()


def get_users(db: _orm.Session, skip: int = 0, limit: int = 100):
    return db.query(_models.User).offset(skip).limit(limit).all()

def get_meanrssi(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.weight_rssi.mean_rssi1).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    result2 = db.query(_models.weight_rssi.mean_rssi2).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    result3 = db.query(_models.weight_rssi.mean_rssi3).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    result4 = db.query(_models.weight_rssi.mean_rssi4).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    result5 = db.query(_models.weight_rssi.mean_rssi5).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    
    return [result1,result2,result3,result4,result5]

def get_stdrssi(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.weight_rssi.std_rssi1).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    result2 = db.query(_models.weight_rssi.std_rssi2).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    result3 = db.query(_models.weight_rssi.std_rssi3).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    result4 = db.query(_models.weight_rssi.std_rssi4).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()
    result5 = db.query(_models.weight_rssi.std_rssi5).order_by(_models.weight_rssi.id.desc()).filter(_models.weight_rssi.owner_id == deviceID).first()

    return result1,result2,result3,result4,result5


def get_meanrssi1(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.Post.RSSI1).filter(_models.Post.owner_id == deviceID).all()
    result2 = db.query(_models.Post.RSSI2).filter(_models.Post.owner_id == deviceID).all()
    result3 = db.query(_models.Post.RSSI3).filter(_models.Post.owner_id == deviceID).all()
    result4 = db.query(_models.Post.RSSI4).filter(_models.Post.owner_id == deviceID).all()
    result5 = db.query(_models.Post.RSSI5).filter(_models.Post.owner_id == deviceID).all()
    
    return [np.average(result1),np.average(result2),np.average(result3),np.average(result4),np.average(result5)]

def get_stdrssi1(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.Post.RSSI1).filter(_models.Post.owner_id == deviceID).all()
    result2 = db.query(_models.Post.RSSI2).filter(_models.Post.owner_id == deviceID).all()
    result3 = db.query(_models.Post.RSSI3).filter(_models.Post.owner_id == deviceID).all()
    result4 = db.query(_models.Post.RSSI4).filter(_models.Post.owner_id == deviceID).all()
    result5 = db.query(_models.Post.RSSI5).filter(_models.Post.owner_id == deviceID).all()

    return [np.std(result1),np.std(result2),np.std(result3),np.std(result4),np.std(result5)]

def get_meanrssi2(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.rssi.rssi1).filter(_models.rssi.owner_id == deviceID).all()
    result2 = db.query(_models.rssi.rssi2).filter(_models.rssi.owner_id == deviceID).all()
    result3 = db.query(_models.rssi.rssi3).filter(_models.rssi.owner_id == deviceID).all()
    result4 = db.query(_models.rssi.rssi4).filter(_models.rssi.owner_id == deviceID).all()
    result5 = db.query(_models.rssi.rssi5).filter(_models.rssi.owner_id == deviceID).all()
    
    return [np.average(result1),np.average(result2),np.average(result3),np.average(result4),np.average(result5)]

def get_stdrssi2(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.rssi.rssi1).filter(_models.rssi.owner_id == deviceID).all()
    result2 = db.query(_models.rssi.rssi2).filter(_models.rssi.owner_id == deviceID).all()
    result3 = db.query(_models.rssi.rssi3).filter(_models.rssi.owner_id == deviceID).all()
    result4 = db.query(_models.rssi.rssi4).filter(_models.rssi.owner_id == deviceID).all()
    result5 = db.query(_models.rssi.rssi5).filter(_models.rssi.owner_id == deviceID).all()

    return [np.std(result1),np.std(result2),np.std(result3),np.std(result4),np.std(result5)]


def get_meandist(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.weight_dist.mean_dist1).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    result2 = db.query(_models.weight_dist.mean_dist2).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    result3 = db.query(_models.weight_dist.mean_dist3).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    result4 = db.query(_models.weight_dist.mean_dist4).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    result5 = db.query(_models.weight_dist.mean_dist5).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    
    return [result1,result2,result3,result4,result5]

def get_stddist(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.weight_dist.std_dist1).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    result2 = db.query(_models.weight_dist.std_dist2).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    result3 = db.query(_models.weight_dist.std_dist3).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    result4 = db.query(_models.weight_dist.std_dist4).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()
    result5 = db.query(_models.weight_dist.std_dist5).order_by(_models.weight_dist.id.desc()).filter(_models.weight_dist.owner_id == deviceID).first()

    return result1,result2,result3,result4,result5




def get_stdpos(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.data_pos.x).filter(_models.data_pos.owner_id == deviceID).all()
    result2 = db.query(_models.data_pos.y).filter(_models.data_pos.owner_id == deviceID).all()
   

    return [np.std(result1)**2 + np.std(result2)**2]


def get_meandist1(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.Post_dist.DIST1).filter(_models.Post_dist.owner_id == deviceID).all()
    result2 = db.query(_models.Post_dist.DIST2).filter(_models.Post_dist.owner_id == deviceID).all()
    result3 = db.query(_models.Post_dist.DIST3).filter(_models.Post_dist.owner_id == deviceID).all()
    result4 = db.query(_models.Post_dist.DIST4).filter(_models.Post_dist.owner_id == deviceID).all()
    result5 = db.query(_models.Post_dist.DIST5).filter(_models.Post_dist.owner_id == deviceID).all()
    
    return [np.average(result1),np.average(result2),np.average(result3),np.average(result4),np.average(result5)]

def get_stddist1(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.Post_dist.DIST1).filter(_models.Post_dist.owner_id == deviceID).all()
    result2 = db.query(_models.Post_dist.DIST2).filter(_models.Post_dist.owner_id == deviceID).all()
    result3 = db.query(_models.Post_dist.DIST3).filter(_models.Post_dist.owner_id == deviceID).all()
    result4 = db.query(_models.Post_dist.DIST4).filter(_models.Post_dist.owner_id == deviceID).all()
    result5 = db.query(_models.Post_dist.DIST5).filter(_models.Post_dist.owner_id == deviceID).all()

    return [np.std(result1),np.std(result2),np.std(result3),np.std(result4),np.std(result5)]

def get_meandist2(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.dist.dist1).filter(_models.dist.owner_id == deviceID).all()
    result2 = db.query(_models.dist.dist2).filter(_models.dist.owner_id == deviceID).all()
    result3 = db.query(_models.dist.dist3).filter(_models.dist.owner_id == deviceID).all()
    result4 = db.query(_models.dist.dist4).filter(_models.dist.owner_id == deviceID).all()
    result5 = db.query(_models.dist.dist5).filter(_models.dist.owner_id == deviceID).all()
    
    return [np.average(result1),np.average(result2),np.average(result3),np.average(result4),np.average(result5)]

def get_stddist2(db: _orm.Session, deviceID: str):
    result1 = db.query(_models.dist.dist1).filter(_models.dist.owner_id == deviceID).all()
    result2 = db.query(_models.dist.dist2).filter(_models.dist.owner_id == deviceID).all()
    result3 = db.query(_models.dist.dist3).filter(_models.dist.owner_id == deviceID).all()
    result4 = db.query(_models.dist.dist4).filter(_models.dist.owner_id == deviceID).all()
    result5 = db.query(_models.dist.dist5).filter(_models.dist.owner_id == deviceID).all()

    return [np.std(result1),np.std(result2),np.std(result3),np.std(result4),np.std(result5)]

def create_user(db: _orm.Session, user: _schemas.UserCreate):
    db_user = _models.User(deviceID=user.deviceID, )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def get_posts(db: _orm.Session, deviceID: str, skip: int = 0, limit: int = 1):
    
    return db.query(_models.User_pos).order_by(_models.User_pos.id.desc()).filter(_models.User_pos.owner_id == deviceID).limit(limit).all()
    
def get_posts1(db: _orm.Session, deviceID: str):
    
    return db.query(_models.User_pos).order_by(_models.User_pos.id.desc()).filter(_models.User_pos.owner_id == deviceID).first()





def create_post(db: _orm.Session, post: _schemas.PostCreate, deviceID: str):
    post = _models.Post(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post

def create_post1(db: _orm.Session, post: _schemas.PostCreate1, deviceID: str):
    post = _models.User_pos(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post

def create_postdist(db: _orm.Session, post: _schemas.Postdistcreate, deviceID: str):
    post = _models.Post_dist(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post

def create_rssi(db: _orm.Session, post: _schemas.rssicreate, deviceID: str):
    post = _models.rssi(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post

def create_dist(db: _orm.Session, post: _schemas.distcreate, deviceID: str):
    post = _models.dist(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post

def create_pos(db: _orm.Session, post: _schemas.poscreate, deviceID: str):
    post = _models.data_pos(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post


def create_weightdist(db: _orm.Session, post: _schemas.weightdist_create, deviceID: str):
    post = _models.weight_dist(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post


def create_weightrssi(db: _orm.Session, post: _schemas.weightrssi_create, deviceID: str):
    post = _models.weight_rssi(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post

def create_weightpos(db: _orm.Session, post: _schemas.weightposition_create, deviceID: str):
    post = _models.weight_position(**post.dict(), owner_id=deviceID)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post


def get_post(db: _orm.Session, post_id: int):
    return db.query(_models.Post).filter(_models.Post.id == post_id).first()


def delete_post(db: _orm.Session, deviceID: str):
    db.query(_models.Post).filter(_models.Post.owner_id == deviceID).delete()
    db.commit()

def delete_rssi(db: _orm.Session, deviceID: str):
    db.query(_models.rssi).filter(_models.rssi.owner_id == deviceID).delete()
    db.commit()

def delete_dist(db: _orm.Session, deviceID: str):
    db.query(_models.dist).filter(_models.dist.owner_id == deviceID).delete()
    db.commit()

def delete_pos(db: _orm.Session, deviceID: str):
    db.query(_models.data_pos).filter(_models.data_pos.owner_id == deviceID).delete()
    db.commit()

def delete_Postdist(db: _orm.Session, deviceID: str):
    db.query(_models.Post_dist).filter(_models.Post_dist.owner_id == deviceID).delete()
    db.commit()


def update_post(db: _orm.Session, post_id: int, post: _schemas.PostCreate):
    db_post = get_post(db=db, post_id=post_id)
    db_post.RSSI1 = post.RSSI1
    db_post.RSSI2 = post.RSSI2
    db_post.RSSI3 = post.RSSI3
    db_post.RSSI4 = post.RSSI4
    db_post.RSSI5 = post.RSSI5
    
    db.commit()
    db.refresh(db_post)
    return db_post

