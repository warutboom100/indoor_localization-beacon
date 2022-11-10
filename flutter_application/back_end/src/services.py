from typing import List

import sqlalchemy.orm as _orm
from models import User

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


def create_user(db: _orm.Session, user: _schemas.UserCreate):
    db_user = _models.User(deviceID=user.deviceID, )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def get_posts(db: _orm.Session, deviceID: str, skip: int = 0, limit: int = 10):
    
    return db.query(_models.User_pos).order_by(_models.User_pos.id.desc()).filter(_models.User_pos.owner_id == deviceID).limit(limit).all()
    

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


def get_post(db: _orm.Session, post_id: int):
    return db.query(_models.Post).filter(_models.Post.id == post_id).first()


def delete_post(db: _orm.Session, post_id: int):
    db.query(_models.Post).filter(_models.Post.id == post_id).delete()
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

